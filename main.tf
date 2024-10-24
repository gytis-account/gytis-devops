provider "aws" {
  region = var.region
}

# VPC Configuration
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name               = var.vpc_name
  cidr               = var.vpc_cidr

  azs                = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags               = var.tags
}

# EKS Configuration
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  eks_managed_node_groups = {
    node_group = {
      instance_types = var.worker_instance_type
      min_size       = var.worker_min_size
      max_size       = var.worker_max_size
      desired_size   = var.worker_desired_size
    }
  }

  tags = var.tags
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_caller_identity" "current" {}

# IAM Configuration
resource "aws_iam_role" "eks_admin" {
  name = var.eks_admin_role_name

  assume_role_policy = data.aws_iam_policy_document.eks_admin_assume_role.json
}

resource "aws_iam_role" "eks_readonly" {
  name = var.eks_readonly_role_name

  assume_role_policy = data.aws_iam_policy_document.eks_readonly_assume_role.json
}

resource "aws_iam_role" "eks_cluster" {
  name = var.eks_cluster_role_name

  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json
}

resource "aws_iam_role" "eks_nodes" {
  name = var.eks_nodes_role_name

  assume_role_policy = data.aws_iam_policy_document.eks_nodes_assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

data "aws_iam_policy_document" "eks_admin_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "eks_readonly_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "eks_nodes_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
