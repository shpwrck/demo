output "lbpip" {
  value = google_compute_address.lbpip.address
}

output "vmpips" {
  value = google_compute_instance.rancherserver.*.network_interface.0.access_config.0.nat_ip
}

output "user" {
  value = "ubuntu"
}
