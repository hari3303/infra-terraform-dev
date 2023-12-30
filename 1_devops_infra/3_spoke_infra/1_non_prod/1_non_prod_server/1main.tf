provider "aws" {
    #access_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxx" # now no need of "${}" its deprected
    #secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" #here accesskey and secret key already configred in kops cmd using aws configure so now no here no need to provide 
    #region = "us-east-1"
    # #version = "~>2.0" #means from 2.0 version to 3.0 in between a stable version is downloaded 
}

module "nonprod_backend_s3" {
  source = "../../../1_hub_and_spoke_basic_modules/1_network/9_backend_terraform"
  
  bucketname = var.bucketname
  acl = var.acl  
  versioning = var.versioning  
  prevent_destroy = var.prevent_destroy
  
}
module "non_prod_network" {
  source = "../../../1_hub_and_spoke_basic_modules/1_network/1_vpc"
  
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr  
  pub_subnet_1 = var.pub_subnet_1  
  pub_subnet_name_1 = var.pub_subnet_name_1
  IGW_name = var.IGW_name
  Main_Routing_Table = var.Main_Routing_Table
  pub_subnet_2 = var.pub_subnet_2  
  pub_subnet_name_2 = var.pub_subnet_name_2
}
module "sg" {
  source = "../../../1_hub_and_spoke_basic_modules/1_network/2_sg"
  
  vpc_id = module.non_prod_network.vpc_id
}

module "nat" {
  source = "../../../1_hub_and_spoke_basic_modules/1_network/3_nat"

  subnet_id = module.non_prod_network.pub_subnet_id_1
  vpc_id = module.non_prod_network.vpc_id
  pvt_subnet = var.pvt_subnet
  pvt_subnet_name = var.pvt_subnet_name
  pvt_subnet_1 = var.pvt_subnet_1
  pvt_subnet_name_1 = var.pvt_subnet_name_1
  pvt_rt = var.pvt_rt
}


module "kops_mgmt" {
  source = "../0_modules"  
  
  ami = var.kops_ami
  availability_zone = var.kops_availability_zone
  instance_type = var.kops_instance_type
  key_name = var.kops_key_name
  subnet_id = module.non_prod_network.pub_subnet_id_1
  # subnet_id = module.nat.pvt_subnet_id
  vpc_security_group_ids = module.sg.vpc_security_group_ids
  instance_name = var.kops_instance_name
  associate_public_ip_address = var.associate_public_ip_address
  user_data  = "${file("../2_non_prod_userdata_files_servers/1_kops.sh")}"
}



# module "pvt_route53" {
#   source = "../../1_hub_and_spoke_basic_modules/1_network/7_route53_pvt"

#   hz_name       = var.hz_name
#   vpc_id        = module.hub_network.vpc_id
#   route53_records = var.route53_records

# }

module "ecr_pvt" {
  source                = "../../../1_hub_and_spoke_basic_modules/1_network/8_ecr_pvt"
  repository_names      = var.repository_names
  image_expiration_days = var.image_expiration_days
  image_tag_mutability = var.image_tag_mutability
}