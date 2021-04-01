module "iam_users" {
  source = "github.com/olivr-com/terraform-aws-bulk-iam-users"

  force_destroy         = true
  create_access_keys    = true
  create_login_profiles = true
  pgp_key               = "keybase:simonjgr"

  users_groups       = {
    simonjgr = ["Interns"]
  }

  tags               = {
    Department  = "Interns"
  }

  module_depends_on = [module.iam_groups.groups]
}

