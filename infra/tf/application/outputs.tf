output "aws_lb_target_group_arn" {
  value       = module.lb.target_group_arn
  description = "load balancer target group"
}

output "aws_lb_url" {
  value       = module.lb.lb_dns_name
  description = "direct dns access to the load balancer"
}

output "aws_dns_record" {
  value       = aws_route53_record.this.fqdn
  description = "the domain name which the desployed application should be accessible via"
}
