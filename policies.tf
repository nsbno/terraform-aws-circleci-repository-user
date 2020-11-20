data "aws_iam_policy_document" "ecr_for_user" {
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

data "aws_iam_policy_document" "s3_write_for_user" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:List*",
    ]
    resources = concat(var.allowed_s3_arns, formatlist("%s/*", var.allowed_s3_arns))
  }
}

data "aws_iam_policy_document" "s3_read_for_user" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
    ]
    resources = concat(var.allowed_s3_arns, formatlist("%s/*", var.allowed_s3_arns))
  }
}
