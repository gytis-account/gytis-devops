variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "vpc_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "The availability zones for the VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "The public subnets for the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "The private subnets for the VPC"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "demo"
    Project     = "Atlantis-EKS"
    Owner       = "Gytis"
  }
}

variable "eks_admin_role_name" {
  description = "The name of the EKS admin role"
  type        = string
}

variable "eks_readonly_role_name" {
  description = "The name of the EKS read-only role"
  type        = string
}

variable "eks_cluster_role_name" {
  description = "The name of the EKS cluster role"
  type        = string
}

variable "eks_nodes_role_name" {
  description = "The name of the EKS nodes role"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
}

variable "worker_instance_type" {
  description = "The instance type for the worker nodes"
  type        = list(string)
}

variable "worker_min_size" {
  description = "The minimum number of workers in the autoscaling group"
  type        = number
}

variable "worker_max_size" {
  description = "The maximum number of workers in the autoscaling group"
  type        = number
}

variable "worker_desired_size" {
  description = "The desired number of workers in the autoscaling group"
  type        = number
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "The CIDRs for public access to the EKS cluster endpoint"
  type        = list(string)
}

variable "github_token" {
  description = "GitHub token for Atlantis"
  type        = string
  sensitive   = true
}

variable "github_webhook_secret" {
  description = "GitHub webhook secret for Atlantis"
  type        = string
  sensitive   = true
}

variable "github_repository" {
  description = "GitHub repository for Atlantis"
  type        = string
}

variable "atlantis_hostname" {
  description = "Hostname for Atlantis ingress"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
}

variable "atlantis_tfstate" {
  description = "The name of the Terraform state file in the S3 bucket"
  type        = string
}