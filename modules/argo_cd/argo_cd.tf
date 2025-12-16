resource "kubernetes_namespace" "argo_cd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  namespace = kubernetes_namespace.argo_cd.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]

  timeout = 600
}
