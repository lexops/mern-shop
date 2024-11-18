data "aws_caller_identity" "current" {}

module "secrets_manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.3.1"

  # Secret
  name_prefix             = var.name
  description             = "Example Secrets Manager secret"
  recovery_window_in_days = 0

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [{
        type = "AWS"
        identifiers = [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
          "${data.aws_caller_identity.current.arn}"
        ]
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  tags = var.tags
}
