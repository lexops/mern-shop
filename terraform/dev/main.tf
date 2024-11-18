terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.1"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }

  backend "s3" {
    bucket  = "desafio-hotmart-tfstate"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  name   = "mern-shop"
  region = "us-east-1"
  domain = "lexops.xyz"
  tags = {
    Team        = "DevOps"
    Environment = "Dev"
  }
}

# module "networking" {
#   source = "../modules/networking"

#   name   = local.name
#   region = local.region
#   tags   = local.tags
# }

# module "k8s" {
#   source = "../modules/k8s"

#   name       = local.name
#   vpc_id     = module.networking.vpc_id
#   subnet_ids = module.networking.vpc_private_subnets
#   tags       = local.tags
# }

# module "k8s_addons" {
#   source = "../modules/k8s-addons"

#   hosted_zone_name      = local.domain
#   eks_oidc_provider_arn = module.k8s.oidc_provider_arn
#   eks_cluster_name      = module.k8s.cluster_name
# }

module "secrets" {
  source = "../modules/secrets"

  name = local.name
  tags = local.tags
}

#foo bar baz 456
