data "aws_acm_certificate" "acm_cert" {
  domain   = var.domain  
  statuses = var.statuses
}
resource "aws_ec2_client_vpn_endpoint" "pvt" {

  description            = var.description
  server_certificate_arn = data.aws_acm_certificate.acm_cert.arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel

  dns_servers = var.dns_servers

   authentication_options {
    type         = "directory-service-authentication"
    active_directory_id = var.directory_id
  }

  connection_log_options {
    enabled = false
  }
  vpc_id      = var.vpc_id
  # security_group_id      = var.security_group_id
  
  tags = {
    Name = "ClientVPN"
  }

}

resource "aws_ec2_client_vpn_network_association" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.pvt.id
  subnet_id              = var.subnet_id
}
resource "aws_ec2_client_vpn_authorization_rule" "authorization_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.pvt.id
  target_network_cidr    = var.target_network_cidr  # Replace with your target network CIDR
  authorize_all_groups   = var.authorize_all_groups
}


resource "aws_ec2_client_vpn_route" "default_route" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.pvt.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = var.subnet_id
  timeouts {
    create = "10m"  # Increase the timeout
  }
}

# resource "null_resource" "client_vpn_ingress" {
#   depends_on = [aws_ec2_client_vpn_endpoint.pvt]
#   provisioner "local-exec" {
#     when    = create
#     command = "aws ec2 authorize-client-vpn-ingress --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.pvt.id} --target-network-cidr 0.0.0.0/0 --authorize-all-groups"
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "null_resource" "export_endpoint_configuration" {
#   depends_on = [null_resource.client_vpn_ingress]
#   provisioner "local-exec" {
#     when    = create
#     command = "aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.pvt.id}  --output text > ../certs/client-config.ovpn"
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "null_resource" "append_client_certificate" {
#   depends_on = [null_resource.export_endpoint_configuration]
#   provisioner "local-exec" {
#     when    = create
#     command = "echo 'cert ${replace(path.cwd,"vpc","certs")}/client1.domain.tld.crt'  >> ../certs/client-config.ovpn"
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "null_resource" "append_client_key" {
#   depends_on = [null_resource.export_endpoint_configuration]
#   provisioner "local-exec" {
#     when    = create
#     command = "echo 'key ${replace(path.cwd,"vpc","certs")}/client1.domain.tld.key'  >> ../certs/client-config.ovpn"
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }