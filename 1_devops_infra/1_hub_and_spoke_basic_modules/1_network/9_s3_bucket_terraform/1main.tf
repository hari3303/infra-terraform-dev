resource "aws_s3_bucket" "hub_terraform_state" {
  bucket = var.bucketname  # Specify a globally unique bucket name
  acl    = var.acl  # Set the ACL (Access Control List) for the bucket

  versioning {
    enabled = var.versioning  # Enable versioning for the bucket
  }

  lifecycle {
    prevent_destroy = false  # Prevent accidental deletion of the bucket
  }
}