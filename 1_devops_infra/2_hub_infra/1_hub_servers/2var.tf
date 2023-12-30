variable "bucketname" {}
variable "acl" {}
variable "versioning" {}


###################################################
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "pub_subnet_1" {}
variable "pub_subnet_name_1"{}
variable "pub_subnet_2" {}
variable "pub_subnet_name_2"{}
variable "IGW_name" {}
variable Main_Routing_Table {}

###############################################################

variable "pvt_subnet" {}
variable "pvt_subnet_name"{}
variable "pvt_subnet_1" {}
variable "pvt_subnet_name_1"{}
variable "pvt_rt" {}

####################################################################
variable "associate_public_ip_address" {}
################################################
variable "jenkins_ami" {}
variable "jenkins_availability_zone" {}
variable "jenkins_instance_type" {}
variable "jenkins_key_name" {}
variable "jenkins_instance_name" {}
##############################################################3

variable "sonarqube_ami" {}
variable "sonarqube_availability_zone" {}
variable "sonarqube_instance_type" {}
variable "sonarqube_key_name" {}
variable "sonarqube_instance_name" {}

###########################################################

variable "prometheus_ami" {}
variable "prometheus_availability_zone" {}
variable "prometheus_instance_type" {}
variable "prometheus_key_name" {}
variable "prometheus_instance_name" {}

############################################################

variable "grafana_ami" {}
variable "grafana_availability_zone" {}
variable "grafana_instance_type" {}
variable "grafana_key_name" {}
variable "grafana_instance_name" {}

###################################################################

variable "elk_ami" {}
variable "elk_availability_zone" {}
variable "elk_instance_type" {}
variable "elk_key_name" {}
variable "elk_instance_name" {}

###############################################################
