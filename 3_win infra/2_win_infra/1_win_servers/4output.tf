output "ad_instance_public_3306" {
  description ="ips"
  value = module.ad_instance.public_ip
}
output "ad_instance_private" {
  description ="ips"
   value = module.ad_instance.private_ip
}

output "directory_service_id" {
  value = module.aws_MAD.directory_service_id
}

