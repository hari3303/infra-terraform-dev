output "kops_mgmt_public" {
  description ="ips"
  value = module.kops_mgmt.public_ip
}
output "kops_mgmt_private" {
  description ="ips"
   value = module.kops_mgmt.private_ip
}