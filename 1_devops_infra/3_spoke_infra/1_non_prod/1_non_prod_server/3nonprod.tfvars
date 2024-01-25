

vpc_cidr = "10.4.0.0/16"
vpc_name = "1_non_prod_infra"
pub_subnet_1 = "10.4.1.0/24"
pub_subnet_name_1 ="1_non_prod_pub_sub_1"
pub_subnet_2 = "10.4.2.0/24"
pub_subnet_name_2 ="1_non_prod_pub_sub_2"
pvt_subnet = "10.4.3.0/24"
pvt_subnet_name ="1_non_prod_pvt_sub"
pvt_subnet_1 = "10.4.4.0/24"
pvt_subnet_name_1 = "1_non_prod_pvt_sub_1"
IGW_name = "1_non_prod"
Main_Routing_Table = "1_non_prod"
pvt_rt = "1_non_prod_pvt-route-table"

kops_ami = "ami-0557a15b87f6559cf"
kops_availability_zone = "us-east-1a"
#kops_availability_zones = ["us-east-1a", "us-east-1b"]  # Specify the desired AZs
kops_instance_type = "t2.micro"
kops_key_name = "non_prod_key"
kops_instance_name = "non_prod_kops_server"
associate_public_ip_address= true


# hz_name         = "hbgseries.in"
# route53_records = []

repository_names = ["frontend_non_prod", "backend_non_prod"]
image_expiration_days = 30
image_tag_mutability = "MUTABLE" #"IMMUTABLE"(can't overwritten the tags or images if it is immutable,if mutable the images and tags can be overwritten(in aws console it is displayed as disable(mutable)))
