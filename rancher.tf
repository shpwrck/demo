resource "rancher2_bootstrap" "admin" {
  depends_on = [
    module.infra,
    rke_cluster.cluster,
    helm_release.cert_manager,
    helm_release.rancher
  ]

  provider  = rancher2.bootstrap
  password  = "admin"
  telemetry = true
}
