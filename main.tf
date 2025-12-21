terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
  }

  backend "s3" {
    bucket         = "lesson-9-mykola-kushka-tfstate-001"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "lesson-9-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.this.certificate_authority[0].data
  )

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.this.name]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.this.certificate_authority[0].data
    )

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.this.name]
    }
  }
}

module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name    = var.tf_state_bucket_name
  dynamodb_table = var.tf_locks_table_name
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr_block
  aws_region     = var.aws_region
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "lesson7-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role" {
  name = "lesson7-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ecr_access" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

module "eks" {
  source = "./modules/eks"

  cluster_name         = var.cluster_name
  subnet_ids           = module.vpc.public_subnets
  cluster_role_arn     = aws_iam_role.eks_cluster_role.arn
  node_role_arn        = aws_iam_role.eks_node_role.arn
  cluster_dependencies = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

module "ecr" {
  source = "./modules/ecr"

  ecr_name = var.ecr_repo_name
}

module "jenkins" {
  source = "./modules/jenkins"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  namespace     = "jenkins"
  chart_version = var.jenkins_chart_version
  values        = file("${path.module}/modules/jenkins/values.yaml")
}

module "argo_cd" {
  source = "./modules/argo_cd"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  namespace     = "argocd"
  chart_version = var.argocd_chart_version
}
