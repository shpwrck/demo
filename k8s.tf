resource "kubernetes_namespace" "cattle" {
  depends_on = [
    module.infra,
    rke_cluster.cluster
  ]

  metadata {
    name = "cattle-system"
  }
}

resource "kubernetes_namespace" "cert" {
  depends_on = [
    module.infra,
    rke_cluster.cluster
  ]

  metadata {
    name = "cert-manager"
    labels = {
      "certmanager.k8s.io/disable-validation" = true
    }
  }
}

resource "helm_release" "cert_manager" {
  depends_on = [
    module.infra,
    rke_cluster.cluster
  ]

  name       = "cert-manager"
  namespace  = "cert-manager"
  repository = data.helm_repository.jetstack.metadata[0].name
  version    = var.cert_manager_version
  chart      = "cert-manager"
}

resource "helm_release" "rancher" {
  depends_on = [
    module.infra,
    rke_cluster.cluster,
    helm_release.cert_manager
  ]

  name       = "rancher"
  namespace  = "cattle-system"
  version    = var.rancher_version
  repository = data.helm_repository.rancher.metadata[0].name
  chart      = "rancher"

  set {
    name  = "hostname"
    value = "${replace(module.infra.lbpip, ".", "-")}.nip.io"
  }

  #  set {
  #    name  = "ingress.tls.source"
  #    value = "letsEncrypt"
  #  }
  #
  #  set {
  #    name  = "letsEncrypt.email"
  #    value = var.le_email
  #  }
}
