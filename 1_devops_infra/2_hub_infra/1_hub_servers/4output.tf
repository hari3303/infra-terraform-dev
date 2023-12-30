output "jenkins_public_8080" {
  description ="ips"
  value = module.jenkins_instance.public_ip
}
output "jenkins_private" {
  description ="ips"
   value = module.jenkins_instance.private_ip
}

output "sonarqube_public_9000" {
  description ="ips"
  value = module.sonarqube_instance.public_ip
}
output "sonarqube_private" {
  description ="ips"
   value = module.sonarqube_instance.private_ip
}

output "prometheus_public_9090" {
  description ="ips"
  value = module.prometheus_instance.public_ip
}
output "prometheus_private" {
  description ="ips"
   value = module.prometheus_instance.private_ip
}

output "grafana_public_3000" {
  description ="ips"
  value = module.grafana_instance.public_ip
}
output "grafana_private" {
  description ="ips"
   value = module.grafana_instance.private_ip
}

output "elk_public_9200_5601" {
  description ="ips"
  value = module.elk_instance.public_ip
}
output "elk_private" {
  description ="ips"
   value = module.elk_instance.private_ip
}

