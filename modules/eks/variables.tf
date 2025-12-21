variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for EKS"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM role for EKS cluster"
}

variable "node_role_arn" {
  type        = string
  description = "IAM role for nodes"
}

variable "cluster_dependencies" {
  description = "List of dependencies required before cluster creation"
  default     = []
}
