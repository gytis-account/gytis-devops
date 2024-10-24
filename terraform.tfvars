account_id           = "054037101494"
region               = "eu-north-1"
cluster_name         = "Atlantis-EKS"
s3_bucket_name       = "atlantis-bucket-gytis"
atlantis_tfstate     = "state-files/atlantis.tfstate"
kubernetes_version   = "1.30"
vpc_name             = "Atlantis-VPC"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["eu-north-1a", "eu-north-1b"]
public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets      = ["10.0.3.0/24", "10.0.4.0/24"]
worker_instance_type = ["t2.micro"]
worker_min_size      = 1
worker_max_size      = 2
worker_desired_size  = 1

# Additional variables
atlantis_hostname                    = "Gytis-Atlantis"
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] 
eks_admin_role_name                  = "eks-admin-role"
eks_cluster_role_name                = "eks-cluster-role"
eks_nodes_role_name                  = "eks-nodes-role"
eks_readonly_role_name               = "eks-readonly-role"
github_repository                    = "gytis-account/gytis-devops"