module "iam_groups" {
  source = "github.com/olivr-com/terraform-aws-bulk-iam-groups"

  groups = {
    SuperAdministrators = {
      policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      assume_roles = [
        "arn:aws:iam::111111111111:role/AdministratorRole",
        "arn:aws:iam::222222222222:role/AdministratorRole"
      ]
    }

    Administrators = {
      policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    }

    SomeOtherGroup = {}
}
}
