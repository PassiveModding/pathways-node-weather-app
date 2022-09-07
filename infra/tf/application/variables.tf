variable "app_name" {
  type    = string
  default = "lj-weather-app"
}

variable "container_port" {
  type    = number
  default = 3000
}

variable "tags" {
  default = {}
}

variable "app_image" {
  type    = string
  default = "lj-weather-app"
}

variable "ssm_resource_prefix" {
  type    = string
  default = "lj-pathways-dojo"
}

variable "resource_name_prefix" {
  type    = string
  default = "lj-app"
}
