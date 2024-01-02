
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

################################################################

variable "windows_ami" {}
variable "windows_client_ami" {}
variable "windows_availability_zone" {}
variable "windows_instance_type" {}
variable "windows_key_name" {}
variable "ad_instance_name" {}

###################################################################

####################################################################
variable "associate_public_ip_address" {}
################################################

variable "domain" {}
variable "statuses" {}
variable "description" {}
variable "client_cidr_block" {}
variable "split_tunnel" {}
variable "dns_servers" {}
variable "directory_id" {}
variable "target_network_cidr" {}
variable "authorize_all_groups" {}

##########################################

