data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = module.secrets.secret_id
}

locals {
  ecr       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${local.region}.amazonaws.com"
  mongoUri  = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["MONGO_URI"]
  password  = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["PASSWORD"]
  secretKey = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["SECRET_KEY"]
}

resource "helm_release" "mern_shop" {
  name  = local.environment
  chart = "../../helm/charts/${local.name}"

  set {
    name  = "backend.backend.image.repository"
    value = "${local.ecr}/${local.name}/backend"
  }

  set {
    name  = "backend.backend.image.tag"
    value = var.mern_shop_version
  }
  set {
    name  = "frontend.frontend.image.repository"
    value = "${local.ecr}/${local.name}/frontend"
  }

  set {
    name  = "frontend.frontend.image.tag"
    value = var.mern_shop_version
  }

  set {
    name  = "backendSecrets.mongoUri"
    value = local.mongoUri
  }

  set {
    name  = "backendSecrets.password"
    value = local.password
  }

  set {
    name  = "backendSecrets.secretKey"
    value = local.secretKey
  }

  set {
    name  = "backendConfig.origin"
    value = local.fqdn
  }

  set {
    name  = "frontendConfig.backendUrl"
    value = "${local.fqdn}/api"
  }

  depends_on = [module.k8s_addons]
}
