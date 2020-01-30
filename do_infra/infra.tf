###############################################################################
# Infrastructure 
###############################################################################

resource "digitalocean_droplet" "controller" {
  count              = var.control_count
  image              = "ubuntu-18-04-x64"
  region             = var.location
  size               = "s-4vcpu-8gb"
  name               = "rc-${count.index}"
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
