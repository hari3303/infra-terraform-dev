provider "aws" {
    #access_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxx" # now no need of "${}" its deprected
    #secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" #here accesskey and secret key already configred in windows cmd using aws configure so now no here no need to provide 
    region = "us-east-2"
    # #version = "~>2.0" #means from 2.0 version to 3.0 in between a stable version is downloaded 
}
terraform {
  backend "s3" {
    bucket         = "terraform-state-hbseries"  # create a  pvt S3 bucket first 
    key            = "mailterraform.tfstate"  # State file name
    region         = "us-east-1"  # Set the AWS region where the S3 bucket is located
    encrypt        = true  # Enable server-side encryption for the state file
    #dynamodb_table = "terraform_locks"  # Optional: Use a DynamoDB table for state locking
  }
}


###################################################################################

module "mail_network" {
  source = "../../1_mail_modules/1_network/1_vpc"
  
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
  source = "../../1_mail_modules/1_network/2_sg"
  
  vpc_id = module.mail_network.vpc_id
}

##################################################################################


module "mail_instance" {
  source = "../../1_mail_modules/2_instance/mailserver"  
  
  ami = var.mail_ami
  availability_zone = var.mail_availability_zone
  instance_type = var.mail_instance_type
  key_name = var.mail_key_name
  subnet_id = module.mail_network.pub_subnet_id_1
  # subnet_id = module.nat.pvt_subnet_id
  vpc_security_group_ids = module.sg.vpc_security_group_ids
  instance_name = var.mail_instance_name 
  associate_public_ip_address = var.associate_public_ip_address
  user_data  = "${file("../2_mail_userdata_files_servers/6_mail.sh")}"
  
}
#################################################################################################
