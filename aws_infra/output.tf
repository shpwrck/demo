output "lbpip" {
  value = aws_eip.lbpip.public_ip
}

output "vmpips" {
  value = aws_instance.rancher_server.*.public_ip
}

output "user" {
  value = "ubuntu"
}
