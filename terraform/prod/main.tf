locals {
  name        = var.project_name
  region      = var.region
  environment = "dev"
  domain      = var.domain
  fqdn        = local.domain
  tags        = var.tags
}

module "networking" {
  source = "../modules/networking"

  name   = local.name
  region = local.region
  cidr   = "10.0.0.0/16"
  tags   = local.tags
}

module "k8s" {
  source = "../modules/k8s"

  name       = local.name
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.vpc_private_subnets
  spot       = false
  tags       = local.tags
}

module "k8s_addons" {
  source = "../modules/k8s-addons"

  hosted_zone_name      = local.domain
  eks_oidc_provider_arn = module.k8s.oidc_provider_arn
  eks_cluster_name      = module.k8s.cluster_name
}

module "secrets" {
  source = "../modules/secrets"

  name = "${local.environment}/${local.name}"
  tags = local.tags
}
