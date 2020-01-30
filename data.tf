data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

data "helm_repository" "rancher" {
  name = "rancher-stable"
  url  = "https://releases.rancher.com/server-charts/stable"
}
