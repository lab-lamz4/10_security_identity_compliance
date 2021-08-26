output "aws_iam_id" {
  value = aws_iam_access_key.user.id
}

output "aws_iam_secret" {
  value     = aws_iam_access_key.user.secret
  sensitive = true
}