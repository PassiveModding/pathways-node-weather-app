# lookup the zone for the web domain since it is required for creating a route53 record
data "aws_route53_zone" "this" {
  name         = var.route53_domain_base
  private_zone = false
}

resource "aws_acm_certificate" "this" {
  domain_name       = var.route53_domain_name
  validation_method = "DNS"
}

# iterate and create dns records to validate the ssl certificate by proving domain ownership
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
}

# link the certificate to the fqdn of the web app so traffic is encrypted on access
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}
