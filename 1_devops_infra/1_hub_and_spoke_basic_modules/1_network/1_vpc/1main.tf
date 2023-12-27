
resource "aws_vpc" "hub_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
         }
}

resource "aws_subnet" "pub_subnet_1" {
    vpc_id = "${aws_vpc.hub_vpc.id}"
    cidr_block = "${var.pub_subnet_1}"
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.pub_subnet_name_1}"
    }
}
resource "aws_subnet" "pub_subnet_2" {
    vpc_id = "${aws_vpc.hub_vpc.id}"
    cidr_block = "${var.pub_subnet_2}"
    availability_zone = "us-east-1b"

    tags = {
        Name = "${var.pub_subnet_name_2}"
    }
}
resource "aws_internet_gateway" "hub_vpc" {
    vpc_id = "${aws_vpc.hub_vpc.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.hub_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.hub_vpc.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}

resource "aws_route_table_association" "public_1" {
    subnet_id = "${aws_subnet.pub_subnet_1.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "public_2" {
    subnet_id = "${aws_subnet.pub_subnet_2.id}"
    route_table_id = "${aws_route_table.public.id}"
}



