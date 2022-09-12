variable "route53_domain_base" {
  description = "the domain name registered with route53"
  type        = string
}

variable "route53_domain_name" {
  description = "the domain/subdomain to generate an ssl cert for"
  type        = string
}
