resource "google_compute_address" "lbpip" {
  name = "racherlb"
}

resource "google_compute_forwarding_rule" "rule80" {
  name        = "port80"
  target      = google_compute_target_pool.main.self_link
  port_range  = "80"
  ip_protocol = "TCP"
  ip_address  = google_compute_address.lbpip.address
}

resource "google_compute_forwarding_rule" "rule443" {
  name        = "port443"
  target      = google_compute_target_pool.main.self_link
  port_range  = "443"
  ip_protocol = "TCP"
  ip_address  = google_compute_address.lbpip.address
}

resource "google_compute_target_pool" "main" {
  name = "ranchertp"
  instances = [
    for instance in google_compute_instance.rancherserver :
    "${var.zone}/${instance.name}"
  ]
}

# Configure Resources
resource "google_compute_instance" "rancherserver" {
  count        = 3
  name         = "rancher-${count.index}"
  machine_type = "n1-standard-2"
  zone         = var.zone


  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # ephemeral
    }
  }

  metadata = {
    ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = file("${var.userdatadir}")
  }

  provisioner "local-exec" {
    command    = "sleep 200"
    on_failure = continue
  }

}

resource "google_compute_firewall" "default" {
  name    = "web-firewall"
  network = "default"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}
