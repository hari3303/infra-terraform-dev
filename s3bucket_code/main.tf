module "backend_s3" {
  source = "../../1_mail_modules/1_network/9_s3_bucket_terraform"
  
  bucketname = var.bucketname
  acl = var.acl  
  versioning = var.versioning 
  
}
#############################################
variable "bucketname" {}
variable "acl" {}
variable "versioning" {}

###############################################
bucketname = "terraform-state-hbseries"
acl = "private"
versioning = false
