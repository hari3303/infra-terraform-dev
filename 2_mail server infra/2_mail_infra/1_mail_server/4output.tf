
output "mail_public" {
  description ="ips"
  value = module.mail_instance.public_ip
}
output "mail_private" {
  description ="ips"
   value = module.mail_instance.private_ip
}


