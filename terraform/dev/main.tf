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
  tags = {
    Team        = "DevOps"
    Environment = "Dev"
  }
}

module "networking" {
  source = "../modules/networking"

  name   = "mern-shop"
  region = "us-east-1"
  tags   = local.tags
}

module "k8s" {
  source = "../modules/k8s"

  name       = "mern-shop"
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.vpc_private_subnets
  tags       = local.tags
}

module "k8s_addons" {
  source = "../modules/k8s-addons"

  hosted_zone_name      = "lexops.xyz"
  eks_oidc_provider_arn = module.k8s.oidc_provider_arn
  eks_cluster_name      = module.k8s.cluster_name
}

resource "helm_release" "mern-shop" {
  namespace        = "mern-shop"
  name             = "dev"
  chart            = "../../helm/charts/mern-shop"
  version          = "0.1.0"
  create_namespace = true
  cleanup_on_fail  = true
  atomic           = true

  depends_on = [module.k8s_addons]
}
