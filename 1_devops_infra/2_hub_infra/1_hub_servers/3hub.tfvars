#################################################
vpc_cidr = "10.2.0.0/16"
vpc_name = "1_hub_infra"
pub_subnet_1 = "10.2.1.0/24"
pub_subnet_name_1 ="1_hub_pub_sub_1"
pub_subnet_2 = "10.2.2.0/24"
pub_subnet_name_2 ="1_hub_pub_sub_2"
pvt_subnet = "10.2.3.0/24"
pvt_subnet_name = "1_hub_pvt_sub"
pvt_subnet_1 = "10.2.4.0/24"
pvt_subnet_name_1 = "1_hub_pvt_sub_1"
IGW_name = "1_hub"
Main_Routing_Table = "1_hub"
pvt_rt = "1_hub_pvt-route-table"
#######################################################

associate_public_ip_address= false   ####us-east-1a(public) -1b(pvt server) 
####################################################################
jenkins_ami = "ami-0557a15b87f6559cf"
jenkins_availability_zone = "us-east-1b"
jenkins_instance_type = "t2.small"
jenkins_key_name = "key"
jenkins_instance_name = "1_jenkins_server"

######################################################################

sonarqube_ami = "ami-0557a15b87f6559cf"
sonarqube_availability_zone = "us-east-1b"
sonarqube_instance_type = "t2.large"
sonarqube_key_name = "key"
sonarqube_instance_name = "2_sonarqube_server"

###################################################################

prometheus_ami = "ami-0557a15b87f6559cf"
prometheus_availability_zone = "us-east-1b"
prometheus_instance_type = "t2.small"
prometheus_key_name = "key"
prometheus_instance_name = "3_prometheus_server"

##################################################################

grafana_ami = "ami-0557a15b87f6559cf"
grafana_availability_zone = "us-east-1b"
grafana_instance_type = "t2.small"
grafana_key_name = "key"
grafana_instance_name = "4_grafana_serverr"

#################################################################

elk_ami = "ami-0e83be366243f524a"
elk_availability_zone = "us-east-1b"
elk_instance_type = "t2.large"
elk_key_name = "key"
elk_instance_name = "5_elk_server"

###################################################################
bucketname = "terraform-state-hbseries"
acl = "private"
versioning = false