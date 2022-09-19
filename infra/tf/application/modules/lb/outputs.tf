output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "lb_dns_name" {
  value = aws_lb.this.dns_name
}

output "lb_dns_zone" {
  value = aws_lb.this.zone_id
}

output "lb_security_group_id" {
  value = aws_security_group.lb.id
}
