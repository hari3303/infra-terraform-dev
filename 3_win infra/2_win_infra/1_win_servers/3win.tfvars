
vpc_cidr = "10.1.0.0/16"
vpc_name = "1_win_infra"
pub_subnet_1 = "10.1.1.0/24"
pub_subnet_name_1 ="1_win_pub_sub_1"
pub_subnet_2 = "10.1.2.0/24"
pub_subnet_name_2 ="1_win_pub_sub_2"
pvt_subnet = "10.1.3.0/24"
pvt_subnet_name = "1_win_pvt_sub"
pvt_subnet_1 = "10.1.4.0/24"
pvt_subnet_name_1 = "1_win_pvt_sub_1"
IGW_name = "1_win"
Main_Routing_Table = "1_win"
pvt_rt = "1_win_pvt-route-table"
#######################################################

windows_ami = "ami-09301a37d119fe4c5"
windows_client_ami = "ami-065b889ab5c33720e"
windows_availability_zone = "us-east-1a"
windows_instance_type = "t2.large"
windows_key_name = "key"
ad_instance_name = "AD_server"


####################################################################

associate_public_ip_address= true   ####us-east-1a(public) -1b(pvt server)

####################################################################

domain   = "hbgseries.in"  # Replace with your domain name
statuses = ["ISSUED"]
description            = "clientvpn-endpoint"
client_cidr_block      = "172.20.0.0/16"
split_tunnel           = false
dns_servers = ["10.1.1.168", "10.1.2.119"] #from dir service replace with AD connector ips
directory_id = "d-9067888829"  # Replace with your Active Directory directory ID
target_network_cidr    = "0.0.0.0/0" # Replace with your target network CIDR
authorize_all_groups   = true
#################################################################
