output "lbpip" {
  value = azurerm_public_ip.lb.ip_address
}

output "vmpips" {
  value = azurerm_public_ip.main.*.ip_address
}

output "user" {
  value = "ubuntu"
}
