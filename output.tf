output "rancher-url" {
  value = "https://${replace(module.infra.lbpip, ".", "-")}.nip.io"
}
