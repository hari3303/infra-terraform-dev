
resource "aws_subnet" "pvt_subnet" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "${var.pvt_subnet}"
    availability_zone = "us-east-1b"

    tags = {
        Name = "${var.pvt_subnet_name}"
    }
}
resource "aws_subnet" "pvt_subnet_1" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "${var.pvt_subnet_1}"
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.pvt_subnet_name_1}"
    }
}
resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
        Name = "${var.pvt_rt}"
    }
}
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.pvt_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.pvt_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}
# Elastic IP for NAT gateway
resource "aws_eip" "nat_eip" {
  vpc      = true
}

# NAT gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet_id
}