resource "aws_route53_zone" "private" {
  name = var.hz_name
  
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "private_dns" {
  for_each = { for record in var.route53_records : record.route53_name => record }

  zone_id = aws_route53_zone.private.zone_id
  name    = each.value.route53_name
  type    = "A"
  ttl     = "300"
  records = [each.value.ip]
}
