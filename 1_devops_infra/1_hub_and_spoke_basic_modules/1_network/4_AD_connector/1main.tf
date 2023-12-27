resource "aws_directory_service_directory" "ad_connector" {
  name     = var.ad_connector_name
  password = var.ad_connector_pass
  size     = var.ad_connector_size
  type     = var.ad_connector_type

  connect_settings {
    customer_dns_ips  = var.customer_dns_ips
    customer_username = var.customer_username
    vpc_id            = var.vpc_id  
    subnet_ids        = var.subnet_id
  }
  tags = {
    Name        = "hub-ad-connector"
  }
}