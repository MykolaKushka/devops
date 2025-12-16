# resource "kubernetes_service_account" "kaniko" {
#   metadata {
#     name      = "kaniko-sa"
#     namespace = var.namespace
#   }
# }

# resource "kubernetes_role" "kaniko_role" {
#   metadata {
#     name      = "kaniko-role"
#     namespace = var.namespace
#  }
# 
#   rule {
#     api_groups = [""]
#     resources  = ["pods", "pods/log"]
#     verbs      = ["get", "list", "watch", "create", "delete"]
#   }
# }

# resource "kubernetes_role_binding" "kaniko_binding" {
#   metadata {
#     name      = "kaniko-binding"
#     namespace = var.namespace
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.kaniko_role.metadata[0].name
#   }
# 
#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.kaniko.metadata[0].name
#     namespace = var.namespace
#   }
# }
