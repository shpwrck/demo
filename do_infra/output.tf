output "lbpip" {
  value = digitalocean_loadbalancer.public.ip
}

output "vmpips" {
  value = digitalocean_droplet.controller.*.ipv4_address
}

output "user" {
  value = "root"
}
