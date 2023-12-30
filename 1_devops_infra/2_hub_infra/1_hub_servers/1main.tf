provider "aws" {
    #access_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxx" # now no need of "${}" its deprected
    #secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" #here accesskey and secret key already configred in windows cmd using aws configure so now no here no need to provide 
    #region = "us-east-1"
    # #version = "~>2.0" #means from 2.0 version to 3.0 in between a stable version is downloaded 
}

module "hub_backend_s3" {
  source = "../../1_hub_and_spoke_basic_modules/1_network/9_s3_bucket_terraform"
  
  bucketname = var.bucketname
  acl = var.acl  
  versioning = var.versioning  
}

terraform {
  backend "s3" {
    bucket         = "your-existing-s3-bucket-name"  # Replace with your actual S3 bucket name
    key            = "terraform.tfstate"  # State file name
    region         = "us-east-1"  # Set the AWS region where the S3 bucket is located
    #encrypt        = true  # Enable server-side encryption for the state file
    #dynamodb_table = "terraform_locks"  # Optional: Use a DynamoDB table for state locking
  }
}

data "terraform_remote_state" "hub_backend_s3" {
  backend = "s3"
  config = {
    region = "us-east-1"
  }
}


###################################################################################

module "hub_network" {
  source = "../../1_hub_and_spoke_basic_modules/1_network/1_vpc"
  
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
  source = "../../1_hub_and_spoke_basic_modules/1_network/2_sg"
  
  vpc_id = module.hub_network.vpc_id
}

##################################################################################

module "nat" {
  source = "../../1_hub_and_spoke_basic_modules/1_network/3_nat"

  subnet_id = module.hub_network.pub_subnet_id_1
  vpc_id = module.hub_network.vpc_id
  pvt_subnet = var.pvt_subnet
  pvt_subnet_name = var.pvt_subnet_name
  pvt_subnet_1 = var.pvt_subnet_1
  pvt_subnet_name_1 = var.pvt_subnet_name_1
  pvt_rt = var.pvt_rt
}


#################################################################################

module "jenkins_instance" {
  source = "../../1_hub_and_spoke_basic_modules/2_instance/hub_linux"  
  
  ami = var.jenkins_ami
  availability_zone = var.jenkins_availability_zone
  instance_type = var.jenkins_instance_type
  key_name = var.jenkins_key_name
  # subnet_id = module.hub_network.pub_subnet_id_1
  subnet_id = module.nat.pvt_subnet_id
  vpc_security_group_ids = module.sg.vpc_security_group_ids
  instance_name = var.jenkins_instance_name 
  associate_public_ip_address = var.associate_public_ip_address
  user_data  = "${file("../2_hub_userdata_files_servers/1_jenkins.sh")}"
  
}


#########################################################################################33

module "sonarqube_instance" {
  source = "../../1_hub_and_spoke_basic_modules/2_instance/hub_linux"  
  
  ami = var.sonarqube_ami
  availability_zone = var.sonarqube_availability_zone
  instance_type = var.sonarqube_instance_type
  key_name = var.sonarqube_key_name
  # subnet_id = module.hub_network.pub_subnet_id_1
  subnet_id = module.nat.pvt_subnet_id
  vpc_security_group_ids = module.sg.vpc_security_group_ids
  instance_name = var.sonarqube_instance_name
  associate_public_ip_address = var.associate_public_ip_address 
  user_data  = "${file("../2_hub_userdata_files_servers/2_sonarqube.sh")}"
  
}

###################################################################################

module "prometheus_instance" {
  source = "../../1_hub_and_spoke_basic_modules/2_instance/hub_linux"  
  
  ami = var.prometheus_ami
  availability_zone = var.prometheus_availability_zone
  instance_type = var.prometheus_instance_type
  key_name = var.prometheus_key_name
  # subnet_id = module.hub_network.pub_subnet_id_1
  subnet_id = module.nat.pvt_subnet_id
  vpc_security_group_ids = module.sg.vpc_security_group_ids
  instance_name = var.prometheus_instance_name 
  associate_public_ip_address = var.associate_public_ip_address
  user_data  = "${file("../2_hub_userdata_files_servers/3_prometheus.sh")}"
  
}

#########################################################################################

module "grafana_instance" {
  source = "../../1_hub_and_spoke_basic_modules/2_instance/hub_linux"  
  
  ami = var.grafana_ami
  availability_zone = var.grafana_availability_zone
  instance_type = var.grafana_instance_type
  key_name = var.grafana_key_name
  # subnet_id = module.hub_network.pub_subnet_id_1
  subnet_id = module.nat.pvt_subnet_id
  vpc_security_group_ids = module.sg.vpc_security_group_ids
  instance_name = var.grafana_instance_name 
  associate_public_ip_address = var.associate_public_ip_address
  user_data  = "${file("../2_hub_userdata_files_servers/4_grafana.sh")}"
  
}

########################################################################################

module "elk_instance" {
  source = "../../1_hub_and_spoke_basic_modules/2_instance/hub_linux"  
  
  ami = var.elk_ami
  availability_zone = var.elk_availability_zone
  instance_type = var.elk_instance_type
  key_name = var.elk_key_name
  # subnet_id = module.hub_network.pub_subnet_id_1
  subnet_id = module.nat.pvt_subnet_id
  vpc_security_group_ids = module.sg.vpc_security_group_ids
  instance_name = var.elk_instance_name 
  associate_public_ip_address = var.associate_public_ip_address
  user_data  = "${file("../2_hub_userdata_files_servers/5_elk.sh")}"
  
}

####################################################################################################


