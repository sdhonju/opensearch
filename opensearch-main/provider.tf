#################################
# Environment Account credentials
#################################
provider "aws" {
  region = var.account_region

  assume_role {
    role_arn = var.iam_assume_role
  }
}

#################################
# Network Account credentials
#################################
provider "aws" {
  alias  = "network"
  region = var.account_region

  assume_role {
    role_arn = var.iam_assume_role_network
  }
}