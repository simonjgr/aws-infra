# stage/terragrunt.hcl
remote_state {
  backend = "s3"

  config = {
    bucket = "simonjgr-tfstate"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "infra-tfstate"
  }
}