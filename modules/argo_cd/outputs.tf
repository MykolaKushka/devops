output "argocd_namespace" {
  description = "Namespace where Argo CD is deployed"
  value       = kubernetes_namespace.argo_cd.metadata[0].name
}

output "argocd_release_name" {
  description = "Helm release name for Argo CD"
  value       = helm_release.argo_cd.name
}
