output "s3_bucket_name" {
  value = aws_s3_bucket.hub_terraform_state.bucket
}