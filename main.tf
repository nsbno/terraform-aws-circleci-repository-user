data "aws_caller_identity" "current" {}

resource "aws_iam_user" "circle_ci_machine-user" {
  name                 = "circle-ci-machine-user"
  path                 = "/machine-user/"
  force_destroy        = "true"
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/LimitTerraform"
}

resource "aws_iam_access_key" "circle_ci_machine_user" {
  user = aws_iam_user.circle_ci_machine-user.name
}

resource "aws_ssm_parameter" "pipeline-ci-user-id" {
  name   = "ci-machine-user-id"
  type   = "SecureString"
  value  = aws_iam_access_key.circle_ci_machine_user.id
  key_id = var.ci_parameters_key
}

resource "aws_ssm_parameter" "pipeline-ci-user-key" {
  name   = "ci-machine-user-key"
  type   = "SecureString"
  value  = aws_iam_access_key.circle_ci_machine_user.secret
  key_id = var.ci_parameters_key
}

resource "aws_iam_policy" "push_to_s3" {
  count       = var.allowed_s3_count
  name_prefix = "${var.name_prefix}-push-to-repos"
  description = "This policy allows push access to specific repos"
  policy      = data.aws_iam_policy_document.push_to_s3.json
}

resource "aws_iam_policy" "push_to_ecr" {
  count       = var.allowed_ecr_count
  name_prefix = "${var.name_prefix}-push-to-repos"
  description = "This policy allows push access to specific repos"
  policy      = data.aws_iam_policy_document.push_to_ecr.json
}



data "aws_iam_policy_document" "push_to_ecr" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
    resources = var.allowed_ecr_arns
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "push_to_s3" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = concat(var.allowed_s3_arns, formatlist("%s/*", var.allowed_s3_arns))
  }
}

resource "aws_iam_user_policy_attachment" "ecr-to-ci-machine-user" {
  count      = var.allowed_ecr_count
  user       = aws_iam_user.circle_ci_machine-user.name
  policy_arn = aws_iam_policy.push_to_ecr[0].arn
}

resource "aws_iam_user_policy_attachment" "s3-to-ci-machine-user" {
  count      = var.allowed_s3_count
  user       = aws_iam_user.circle_ci_machine-user.name
  policy_arn = aws_iam_policy.push_to_s3[0].arn
}