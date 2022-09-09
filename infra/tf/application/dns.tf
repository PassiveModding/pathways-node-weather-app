resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${var.resource_name_prefix}.${route53_base_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

data "aws_route53_zone" "this" {
  name         = var.route53_base_domain
  private_zone = false
}

output "aws_dns_record" {
  value = aws_route53_record.this.fqdn
}

resource "aws_acm_certificate" "this" {
  domain_name       = aws_route53_record.this.name
  validation_method = "DNS"

  depends_on = [
    aws_route53_record.this
  ]
}

output "dvo" {
  value = aws_acm_certificate.this.domain_validation_options
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id

  depends_on = [
    aws_route53_record.this
  ]
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]

  depends_on = [
    aws_route53_record.cert
  ]
}
