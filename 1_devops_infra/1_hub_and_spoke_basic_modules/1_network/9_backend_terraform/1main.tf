resource "aws_s3_bucket" "hub_terraform_state" {
  bucket = "var.bucketname"  # Specify a globally unique bucket name
  acl    = "var.acl"  # Set the ACL (Access Control List) for the bucket

  versioning {
    enabled = var.versioning  # Enable versioning for the bucket
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy  # Prevent accidental deletion of the bucket
  }
}

terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.hub_terraform_state.bucket
    key            = "terraform.tfstate"  # State file name
    region         = "us-east-1"  # Set the AWS region where the S3 bucket is located
    #encrypt        = true  # Enable server-side encryption for the state file
    #dynamodb_table = "terraform_locks"  # Optional: Use a DynamoDB table for state locking
  }
}