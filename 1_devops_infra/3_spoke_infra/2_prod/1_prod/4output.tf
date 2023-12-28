output "eks_mgmt_public" {
  description = "ips"
  value       = module.eks_mgmt.public_ip
}
output "eks_mgmt_private" {
  description = "ips"
  value       = module.eks_mgmt.private_ip
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}