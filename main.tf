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

# NOTE: We create separate policy resources instead of inline policies (e.g., using `aws_iam_user_policy`)
# due to a size limit of 2048 bytes on inline policies -- a limit that is fairly easy to hit.
resource "aws_iam_policy" "s3_write" {
  count       = length(var.allowed_s3_write_arns) > 0 ? 1 : 0
  name_prefix = "${var.name_prefix}-circleci-s3-write"
  description = "Policy that grants write access to a list of S3 buckets."
  policy      = data.aws_iam_policy_document.s3_write_for_user.json
}

resource "aws_iam_policy" "s3_read" {
  count       = length(var.allowed_s3_read_arns) > 0 ? 1 : 0
  name_prefix = "${var.name_prefix}-circleci-s3-read"
  description = "Policy that grants read access to a list of S3 buckets."
  policy      = data.aws_iam_policy_document.s3_read_for_user.json
}

resource "aws_iam_policy" "ecr" {
  count       = length(var.allowed_ecr_arns) > 0 ? 1 : 0
  name_prefix = "${var.name_prefix}-circleci-ecr"
  description = "Policy that grants read and write access to a list of ECR repositories."
  policy      = data.aws_iam_policy_document.ecr_for_user.json
}

resource "aws_iam_user_policy_attachment" "s3_write_to_user" {
  count      = length(var.allowed_s3_write_arns) > 0 ? 1 : 0
  user       = aws_iam_user.circle_ci_machine-user.name
  policy_arn = aws_iam_policy.s3_write[0].arn
}

resource "aws_iam_user_policy_attachment" "s3_read_to_user" {
  count      = length(var.allowed_s3_read_arns) > 0 ? 1 : 0
  user       = aws_iam_user.circle_ci_machine-user.name
  policy_arn = aws_iam_policy.s3_read[0].arn
}

resource "aws_iam_user_policy_attachment" "ecr_to_user" {
  count      = length(var.allowed_ecr_arns) > 0 ? 1 : 0
  user       = aws_iam_user.circle_ci_machine-user.name
  policy_arn = aws_iam_policy.ecr[0].arn
}
