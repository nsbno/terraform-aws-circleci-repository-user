/*
 * == User Setup
 */
resource "aws_iam_user" "circle_ci_machine_user" {
  name          = "${var.name_prefix}-circle-ci"
  path          = var.user_path
  force_destroy = "true"
}

resource "aws_iam_access_key" "circle_ci_machine_user" {
  user = aws_iam_user.circle_ci_machine_user.name
}

/*
 * == Permissions
 */
data "aws_iam_policy_document" "allow_artifact_access" {
  statement {
    effect  = "Allow"
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
    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = [
      "s3:PutObject*",
      "s3:List*",
      "s3:Get*",
    ]
    resources = [
      var.artifact_bucket_arn,
      "${var.artifact_bucket_arn}/*",
      var.documentation_portal_bucket_arn,
      "${var.documentation_portal_bucket_arn}/*",
    ]
  }
}

resource "aws_iam_user_policy" "allow_artifact_access" {
  name   = "allow-artifact-access"
  user   = aws_iam_user.circle_ci_machine_user.id
  policy = data.aws_iam_policy_document.allow_artifact_access.json
}

data "aws_iam_policy_document" "allow_deployment_service_access" {
  statement {
    effect    = "Allow"
    actions   = ["execute-api:Invoke"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "allow_deployment_service_access" {
  name   = "allow-deployment-service-access"
  user   = aws_iam_user.circle_ci_machine_user.id
  policy = data.aws_iam_policy_document.allow_deployment_service_access.json
}

/*
 * == Sharing the user access keys
 *
 * Implementors will be adding these to CircleCI.
 */
resource "aws_ssm_parameter" "user_id" {
  name  = "/ci/user-id"
  type  = "SecureString"
  value = aws_iam_access_key.circle_ci_machine_user.id
}

resource "aws_ssm_parameter" "user_secret" {
  name  = "/ci/user-secret"
  type  = "SecureString"
  value = aws_iam_access_key.circle_ci_machine_user.secret
}
