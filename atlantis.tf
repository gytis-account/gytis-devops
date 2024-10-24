# Atlantis Deployment using Helm
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"
  version    = "5.7.0"

  set {
    name  = "vcsSecret.githubToken"
    value = var.github_token
  }

  set {
    name  = "vcsSecret.githubWebhookSecret"
    value = var.github_webhook_secret
  }

  set {
    name  = "config.repositories"
    value = var.github_repository
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.hosts[0].host"
    value = var.atlantis_hostname
  }

  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
}