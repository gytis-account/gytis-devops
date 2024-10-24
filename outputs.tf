output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

#### EKS ####
output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data."
  value       = module.eks.cluster_certificate_authority_data
}

### IAM ###
output "eks_admin_role_arn" {
  value = aws_iam_role.eks_admin.arn
}

output "eks_readonly_role_arn" {
  value = aws_iam_role.eks_readonly.arn
}

### VPC ###
output "subnet_ids" {
  value = module.vpc.private_subnets
}

