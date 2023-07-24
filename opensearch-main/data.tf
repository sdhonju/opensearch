data "terraform_remote_state" "current-vpc" {
  backend = "s3"

  config = {
    bucket = var.environment_state_bucket
    key    = var.vpc_prefix
    region = var.account_region
  }
}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "access_policy" {
  statement {
    actions   = ["es:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
