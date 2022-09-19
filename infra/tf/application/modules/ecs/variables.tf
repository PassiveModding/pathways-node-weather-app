variable "lb_target_group_arn" {
  description = "the target group which the ecs will be assigned to"
  type        = string
}

variable "resource_name_prefix" {
  description = "prefix to all resource names"
  type        = string
}

variable "ecs_subnets" {
  type        = list(string)
  description = "subnets which ecs containers may be deployed to"
}
variable "cpu_scale_up" {
  type        = number
  default     = 60
  description = "max average cpu usage percent before scaling up"
}

variable "mem_scale_up" {
  type        = number
  default     = 80
  description = "max average ram usage percent before scaling up"
}

variable "tags" {
  description = "tags to apply to all resources"
  default     = {}
}

variable "container_port" {
  type        = number
  description = "port used to access the containers provided by the ecr"
}

variable "ecr_name" {
  description = "the name of the ecr which will used as a source for ecs images"
  type        = string
}

variable "vpc_id" {
  description = "vpc the containers are on"
  type        = string
}

variable "ecs_ingress_security_groups" {
  type        = list(string)
  description = "security groups which ingress traffic is allowed to the containers via"
}

variable "region" {
  type        = string
  description = "region resources are on"
}
