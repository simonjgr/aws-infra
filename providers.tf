#----------------------------------------------------#
#      Required Providers with Provider details      #
#----------------------------------------------------#

terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.58"
    }
  }
}