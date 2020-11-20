data "aws_caller_identity" "current" {}

resource "aws_iam_user" "circle_ci_machine-user" {
  name          = "${var.name_prefix}-circle-ci"
  path          = "/machine-user/"
  force_destroy = "true"
}

resource "aws_iam_access_key" "circle_ci_machine_user" {
  user = aws_iam_user.circle_ci_machine-user.name
}

resource "aws_ssm_parameter" "pipeline-ci-user-id" {
  name   = "${var.name_prefix}-ci-machine-user-id"
  type   = "SecureString"
  value  = aws_iam_access_key.circle_ci_machine_user.id
  key_id = var.ci_parameters_key
}

resource "aws_ssm_parameter" "pipeline-ci-user-key" {
  name   = "${var.name_prefix}-ci-machine-user-key"
  type   = "SecureString"
  value  = aws_iam_access_key.circle_ci_machine_user.secret
  key_id = var.ci_parameters_key
}

resource "aws_iam_user_policy" "s3_write_for_user" {
  count       = length(var.allowed_s3_write_arns) > 0 ? 1 : 0
  description = "This policy allows push and list access to specific S3 buckets."
  policy      = data.aws_iam_policy_document.s3_write_to_user.json
}

resource "aws_iam_user_policy" "ecr_to_user" {
  count       = length(var.allowed_ecr_arns) > 0 ? 1 : 0
  description = "This policy allows push access to specific ECR repos."
  user        = aws_iam_user.circle_ci_machine_user.name
  policy      = data.aws_iam_policy_document.ecr_for_user.json
}

resource "aws_iam_user_policy" "s3_read_for_user" {
  count       = length(var.allowed_s3_read_arns) > 0 ? 1 : 0
  description = "This policy allows read access to specific S3 buckets."
  user        = aws_iam_user.circle_ci_machine_user.name
  policy      = data.aws_iam_policy_document.s3_read_for_user.json
}
