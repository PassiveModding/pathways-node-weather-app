# lookup the zone for the web domain since it is required for creating a route53 record
data "aws_route53_zone" "this" {
  name         = var.route53_domain_base
  private_zone = false
}

# setup the subdomain to be used when accessing the web app
resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.route53_domain_name
  type    = "A"

  alias {
    name                   = module.lb.lb_dns_name
    zone_id                = module.lb.lb_dns_zone
    evaluate_target_health = true
  }
}
