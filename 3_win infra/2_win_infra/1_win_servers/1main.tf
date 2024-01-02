provider "aws" {
    #access_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxx" # now no need of "${}" its deprected
    #secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" #here accesskey and secret key already configred in windows cmd using aws configure so now no here no need to provide 
    #region = "us-east-1"
    # #version = "~>2.0" #means from 2.0 version to 3.0 in between a stable version is downloaded 
}
terraform {
  backend "s3" {
    bucket         = "terraform-state-hbseries"  # create a  pvt S3 bucket first 
    key            = "winterraform.tfstate"  # State file name
    region         = "us-east-1"  # Set the AWS region where the S3 bucket is located
    encrypt        = true  # Enable server-side encryption for the state file
    #dynamodb_table = "terraform_locks"  # Optional: Use a DynamoDB table for state locking
  }
}

###################################################################################

module "win_network" {
  source = "../../1_win_modules/1_network/1_vpc"
  
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr  
  pub_subnet_1 = var.pub_subnet_1  
  pub_subnet_name_1 = var.pub_subnet_name_1
  pub_subnet_2 = var.pub_subnet_2  
  pub_subnet_name_2 = var.pub_subnet_name_2
  IGW_name = var.IGW_name
  Main_Routing_Table = var.Main_Routing_Table
  
}

###############################################################################

module "sg" {
  source = "../../1_win_modules/1_network/2_sg"
  
  vpc_id = module.win_network.vpc_id
}

##################################################################################

module "nat" {
  source = "../../1_win_modules/1_network/3_nat"

  subnet_id = module.win_network.pub_subnet_id_1
  vpc_id = module.win_network.vpc_id
  pvt_subnet = var.pvt_subnet
  pvt_subnet_name = var.pvt_subnet_name
  pvt_subnet_1 = var.pvt_subnet_1
  pvt_subnet_name_1 = var.pvt_subnet_name_1
  pvt_rt = var.pvt_rt
}

###################################################################
module "ad_instance" {
  source = "../../1_win_modules/2_instance/windows"  
  
  ami = var.windows_ami
  availability_zone = var.windows_availability_zone
  instance_type = var.windows_instance_type
  key_name = var.windows_key_name
  subnet_id = module.win_network.pub_subnet_id_1
  vpc_security_group_ids = module.sg.vpc_security_group_ids
  instance_name = var.ad_instance_name
  user_data  = "${file("../2_win_userdata_files_servers/0_win.sh")}"
  
}

############################################
module "aws_MAD" {
  source = "../../1_win_modules/1_network/9_aws_microsoft_AD" 

vpc_id = module.win_network.vpc_id
subnet_id = [ module.win_network.pub_subnet_id_1 , module.win_network.pub_subnet_id_2 ]
  
}

##########################################################

module "client_vpn" {
  source = "../../1_win_modules/1_network/5_client_vpn" 
 
  domain   = var.domain  
  statuses = var.statuses
  description            = var.description
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel
  dns_servers = var.dns_servers
  directory_id = var.directory_id 
  subnet_id = module.nat.pvt_subnet_id
  vpc_id = module.win_network.vpc_id
  target_network_cidr    = var.target_network_cidr  
  authorize_all_groups   = var.authorize_all_groups
  # security_group_ids = module.sg.vpc_security_group_ids
}

############################

