variable "vpc_cidr" {}
variable "vpc_name" {}
variable "pub_subnet_1" {}
variable "pub_subnet_name_1" {}
variable "pub_subnet_2" {}
variable "pub_subnet_name_2" {}
variable "IGW_name" {}
variable "Main_Routing_Table" {}

variable "pvt_subnet" {}
variable "pvt_subnet_name" {}
variable "pvt_subnet_1" {}
variable "pvt_subnet_name_1" {}
variable "pvt_rt" {}

variable "eks_ami" {}
variable "eks_availability_zone" {}
variable "eks_instance_type" {}
variable "eks_key_name" {}
variable "eks_instance_name" {}
variable "associate_public_ip_address" {}



# variable "hz_name" {}
# variable "route53_records" {
#   description = "List of objects representing route53 records"
#   type        = list(object({
#     route53_name = string
#     ip           = string
#   }))
#   default     = []
# }

variable "repository_names" {
  type    = list(string)
  default = ["repo1", "repo2", "repo3"] # Add your repository names here
}

variable "image_expiration_days" {
  type    = number
  default = 30 # Number of days after which images will be deleted
}
variable "image_tag_mutability" {}