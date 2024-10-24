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

data "aws_caller_identity" "current" {}

# IAM Configuration
### Configuring eks-readonly role in AWS IAM - policy, role and policy attachment ###
resource "aws_iam_policy" "eks-readonly-policy" {
  name        = "eks_readonly_policy"
  path        = "/"
  description = "Read only policy for eks-readonly role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Sid": "45345354354",
    "Effect": "Allow",
    "Action": [
      "eks:DescribeCluster",
      "eks:ListCluster"
    ],
    "Resource": "*"
    }
}
EOF
}

resource "aws_iam_role" "eks-readonly-role" {
  name = "eks_readonly"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account_id}:root"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks-readonly-policy-attach" {
  role       = aws_iam_role.eks-readonly-role.name
  policy_arn = aws_iam_policy.eks-readonly-policy.arn
}

### Configuring eks-admin role in AWS IAM - policy, role and policy attachment ###
resource "aws_iam_policy" "eks-admin-policy" {
  name        = "eks_admin_policy"
  path        = "/"
  description = "Admin policy for eks-admin role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Sid": "45345354354",
    "Effect": "Allow",
    "Action": [
      "*"
    ],
    "Resource": "*"
    }
}
EOF
}

resource "aws_iam_role" "eks-admin-role" {
  name = "eks_admin"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account_id}:root"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks-admin-policy-attach" {
  role       = aws_iam_role.eks-admin-role.name
  policy_arn = aws_iam_policy.eks-admin-policy.arn
}