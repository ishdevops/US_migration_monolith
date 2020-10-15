resource "aws_route53_zone" "salaryfinance_hosted_zone" {
  name = "salaryfinance.club"
}

resource "aws_route53_record" "us-battasks" {
  zone_id = aws_route53_zone.salaryfinance_hosted_zone.zone_id
  name    = "us-battasks"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.restricted_access_lb.id]
}

resource "aws_route53_record" "us-battasksapi" {
  zone_id = aws_route53_zone.salaryfinance_hosted_zone.zone_id
  name    = "us-battasksapi"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.restricted_access_lb.id]
}