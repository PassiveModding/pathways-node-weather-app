variable "aws_acm_certificate_validation_arn" {
  description = "AWS certificate validation to link to the load balancer listener for SSL traffic"
  type        = string
}

variable "resource_name_prefix" {
  description = "prefix to all resource names"
  type        = string
}

variable "lb_subnets" {
  description = "subnets to link to the load balancer to"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc the lb target group is on"
  type        = string
}

variable "tags" {
  description = "tags to apply to all resources"
  default     = {}
}

variable "default_port" {
  description = "default port for lb to redirect to"
  type        = number
}
