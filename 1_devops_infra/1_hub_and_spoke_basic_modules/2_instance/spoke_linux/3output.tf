output "public_ip" {
  description ="ips"
  value       = [ "${aws_instance.server.*.public_ip}"]
}
output "private_ip" {
  description ="ips"
  value       = [ "${aws_instance.server.*.private_ip}"]
}
