output "validation_certificate_arn" {
  value       = aws_acm_certificate_validation.this.certificate_arn
  description = "the arn of the aws acm certificate validation"
}
