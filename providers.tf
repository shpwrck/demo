provider "kubernetes" {
  host     = rke_cluster.cluster.api_server_url
  username = rke_cluster.cluster.kube_admin_user

  client_certificate     = rke_cluster.cluster.client_cert
  client_key             = rke_cluster.cluster.client_key
  cluster_ca_certificate = rke_cluster.cluster.ca_crt
  load_config_file       = false
}

provider "helm" {
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.16.1"
  service_account = "tiller"

  kubernetes {
    host     = rke_cluster.cluster.api_server_url
    username = rke_cluster.cluster.kube_admin_user

    client_certificate     = rke_cluster.cluster.client_cert
    client_key             = rke_cluster.cluster.client_key
    cluster_ca_certificate = rke_cluster.cluster.ca_crt

    load_config_file = false
  }
}

provider "rancher2" {
  version   = "~>1.7"
  alias     = "bootstrap"
  insecure  = true
  api_url   = "https://${replace(module.infra.lbpip, ".", "-")}.nip.io"
  bootstrap = true
}

provider "rancher2" {
  version   = "~>1.7"
  alias     = "default"
  insecure  = true
  api_url   = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  bootstrap = false
}
