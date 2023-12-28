resource "aws_instance" "server" {
    ami = var.ami
    availability_zone = var.availability_zone
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet_id
    vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
    associate_public_ip_address = true
    user_data = var.user_data
    tags = {
        Name = var.instance_name

    }

}

