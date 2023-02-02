output "user_name" {
  value = aws_iam_user.circle_ci_machine_user.name
}

output "user_arn" {
  value = aws_iam_user.circle_ci_machine_user.arn
}
