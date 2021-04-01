#-------------------------------------------------------------------------#
#      Create IAM Policies and attach them to the relevant IAM Group      #
#-------------------------------------------------------------------------#

data "aws_iam_policy_document" "LimitedAccess" {
  statement {
    sid = "AllowLimitedServices"

    effect = "Allow"

    resources = ["*"]

    actions = [
      "ec2:*",
      "eks:*",
      "kinesis:*",
      "dynamodb:*",
      "kms:*",
      "logs:*",
      "cloudtrail:*",
      "codebuild:*",
      "codecommit:*",
      "codepipeline:*",
      "autoscaling:*",
      "lambda:*",
      "rds:*",
      "route53:*",
      "route53domains:*",
      "secretsmanager:*",
      "ses:*",
      "sns:*",
      "sqs:*",
      "trustedadvisor:*",
      "acm:*",
      "events:*",
      "config:*",
      "cloudwatch:*",
      "ecs:*",
      "elasticloadbalancing:*",
      "cloudformation:CreateUploadBucket",
      "cloudformation:ListStacks",
      "s3:createbucket",
      "cloudformation:GetTemplateSummary",
      "cloudformation:CreateStack"
    ]
  }
  statement {
    sid = "DontDeleteUsers"

    effect = "Allow"

    resources = [
      "arn:aws:iam::435494745887:user/abubakr.samsodien@vaxowave.com",
      "arn:aws:iam::435494745887:user/andrew.stangl@vaxowave.com",
      "arn:aws:iam::435494745887:user/bhekumuzi.sodinga@vaxowave.com",
      "arn:aws:iam::435494745887:user/mxolisi.skhosana@vaxowave.com",
      "arn:aws:iam::435494745887:user/simon.green@vaxowave.com"
    ]

    not_actions = ["iam:DeleteUser"]
  }
  statement {
    sid = "DontDeleteGroups"

    effect = "Allow"

    resources= [
      "arn:aws:iam::435494745887:group/Admin",
      "arn:aws:iam::435494745887:group/Administrators"
      ]

    not_actions = ["iam:DeleteGroup"]
  }
}

resource "aws_iam_policy" "LimitedAccess" {
  name   = "LimitedAccess"
  path   = "/"
  policy = data.aws_iam_policy_document.LimitedAccess.json
}

data "aws_iam_policy_document" "ManageOwnMFA" {
  statement {
    sid = "AllowViewAccountInfo"

    effect = "Allow"

    resources = ["*"]

    actions = ["iam:ListVirtualMFADevices"]
  }
  statement {
    sid = "AllowManageOwnVirtualMFADevice"

    effect = "Allow"

    resources =  ["arn:aws:iam::*:mfa/$${aws:username}"]

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice"
      ]
  }
  statement {
    sid = "AllowManageOwnUserMFA"

    effect = "Allow"

    resources= ["arn:aws:iam::*:user/$${aws:username}"]

    actions = [
      "iam:DeactivateMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListMFADevices",
      "iam:ResyncMFADevice"
      ]
  }
  statement {
    sid = "DenyAllExceptListedIfNoMFA"

    effect = "Deny"

    resources= ["*"]

    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
      "sts:GetSessionToken"
      ]

    condition {
      test = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_iam_policy" "ManageOwnMFA" {
  name   = "ManageOwnMFA"
  path   = "/"
  policy = data.aws_iam_policy_document.ManageOwnMFA.json
}