output "vpc_id" {
  value = aws_vpc.hub_vpc.id
}
output "pub_subnet_id_1" {
  value = aws_subnet.pub_subnet_1.id
}
output "pub_subnet_id_2" {
  value = aws_subnet.pub_subnet_2.id
}