resource "aws_route53_zone" "salaryfinance_hosted_zone" {
  name = "salaryfinance.club"
}

resource "aws_route53_record" "us-battasks" {
  zone_id = aws_route53_zone.salaryfinance_hosted_zone.zone_id
  name    = "us-battasks"
  type    = "A"
  
  alias {
    name                   = aws_lb.restricted_access_lb.dns_name
    zone_id                = aws_lb.restricted_access_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "us-battasksapi" {
  zone_id = aws_route53_zone.salaryfinance_hosted_zone.zone_id
  name    = "us-battasksapi"
  type    = "A"
  
  alias {
    name                   = aws_lb.restricted_access_lb.dns_name
    zone_id                = aws_lb.restricted_access_lb.zone_id
    evaluate_target_health = true
  }
}