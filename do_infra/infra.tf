###############################################################################
# Infrastructure 
###############################################################################

resource "digitalocean_droplet" "controller" {
  count              = var.control_count
  image              = "ubuntu-18-04-x64"
  region             = var.location
  size               = "s-4vcpu-8gb"
  name               = "${var.node_prefix}-${count.index}"
  ssh_keys           = [var.ssh_key]
  user_data          = file(var.userdata)
  private_networking = true

  provisioner "local-exec" {
    command    = "sleep 120"
    on_failure = continue
  }
}

resource "digitalocean_loadbalancer" "public" {
  depends_on = [digitalocean_droplet.controller]

  name   = "loadbalancer"
  region = var.location

  forwarding_rule { # Forward 80
    entry_port     = 80
    entry_protocol = "tcp"

    target_port     = 80
    target_protocol = "tcp"
  }

  forwarding_rule { # Forward 443
    entry_port     = 443
    entry_protocol = "tcp"

    target_port     = 443
    target_protocol = "tcp"
  }

  healthcheck {
    port     = 443
    protocol = "tcp"
  }

  droplet_ids = digitalocean_droplet.controller.*.id
}

resource "digitalocean_firewall" "default" {
  depends_on = [digitalocean_droplet.controller]

  name        = "rancher"
  droplet_ids = digitalocean_droplet.controller[*].id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
