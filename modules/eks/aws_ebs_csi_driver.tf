data "aws_iam_role" "ebs_csi_driver_role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name  = var.cluster_name
  addon_name    = "aws-ebs-csi-driver"

  # щоб конфіг збігався зі станом і Terraform не робив UpdateAddon
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = data.aws_iam_role.ebs_csi_driver_role.arn

  depends_on = [aws_eks_cluster.this]
}
