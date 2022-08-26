variable "tags" {
  default = {}
}

variable "availability_zones" {
  type = list(string)
}

variable "app_name" {
  type = string
}

variable "region" {
  type = string
}
