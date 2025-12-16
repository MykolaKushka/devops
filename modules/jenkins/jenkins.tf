resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = "jenkins"

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.114"

  timeout = 1800
  wait    = true

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.jenkins
  ]
}
