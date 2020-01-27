data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

data "helm_repository" "rancher" {
  name = "rancher-latest"
  url  = "https://releases.rancher.com/server-charts/latest"
}
