resource "helm_release" "jenkins" {
  name      = "jenkins"
  namespace = var.namespace

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version

  timeout = 1800
  wait    = true

  values = [
    var.values
  ]

  depends_on = [
    kubernetes_namespace.jenkins
  ]
}
