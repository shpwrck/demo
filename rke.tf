resource rke_cluster "cluster" {
  depends_on = [
    module.infra
  ]

  dynamic nodes {
    for_each = module.infra.vmpips
    content {
      address = nodes.value
      user    = module.infra.user
      role    = ["controlplane", "worker", "etcd"]
      ssh_key = file("~/.ssh/id_rsa")
    }
  }

  ingress {
    provider = "nginx"
    extra_args = {
      enable-ssl-passthrough = ""
    }
  }

  authentication {
    strategy = "x509"

    sans = [
      module.infra.lbpip,
      "${replace(module.infra.lbpip, ".", "-")}.nip.io"
    ]
  }

  # Remove when CRD's are available
  addons_include = [
    "https://raw.githubusercontent.com/jetstack/cert-manager/release-0.9/deploy/manifests/00-crds.yaml"
  ]

}

#resource "local_file" "linux" {
#  depends_on = [
#    rke_cluster.cluster
#  ]
#
#  filename = "~/.kube/config.rancher"
#  content  = rke_cluster.cluster.kube_config_yaml
#}
