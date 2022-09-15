variable "container_port" {
  type        = number
  default     = 3000
  description = "the port which http traffic will be configured on the container"
}

variable "tags" {
  default     = {}
  description = "additional tags for aws resources"
}


# assumes the existence of the following ssm parameters:
# /${var.ssm_resource_prefix}/vpc/id
# /${var.ssm_resource_prefix}/vpc/region
variable "ssm_resource_prefix" {
  type        = string
  default     = "lj-pathways-dojo"
  description = "first path structure section for ssm resources"
}

variable "ecr_name" {
  type        = string
  default     = "lj-weather-app"
  description = "name of the repo to pull images from"
}

variable "resource_name_prefix" {
  type        = string
  default     = "lj-app"
  description = "1-6 char prefix for all resource names"
}

variable "route53_domain_base" {
  type        = string
  default     = "weatherapp.click"
  description = "route 53 domain name registered on the aws account"
}

variable "route53_domain_name" {
  type        = string
  default     = "lj-app.weatherapp.click"
  description = "the domain/subdomain to generate an ssl cert for"
}
