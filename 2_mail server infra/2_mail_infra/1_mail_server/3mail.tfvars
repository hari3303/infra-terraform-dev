vpc_cidr = "10.3.0.0/16"
vpc_name = "1_mail_infra"
pub_subnet_1 = "10.3.1.0/24"
pub_subnet_name_1 ="1_mail_pub_sub_1"
pub_subnet_2 = "10.3.2.0/24"
pub_subnet_name_2 ="1_mail_pub_sub_2"
IGW_name = "1_mail"
Main_Routing_Table = "1_mail"
#######################################################

associate_public_ip_address= true   ####us-east-2a(public) -2b(pvt server) 
####################################################################

mail_ami = "ami-0e83be366243f524a"
mail_availability_zone = "us-east-2a"
mail_instance_type = "t2.large"
mail_key_name = "mail_key"
mail_instance_name = "6_mail_server"

###################################################################