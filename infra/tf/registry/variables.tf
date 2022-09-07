variable "repo_name" {
  type    = string
  default = "lj-weather-app"
}

variable "tags" {
  default = {}
}

variable "ssm_resource_prefix" {
  type    = string
  default = "lj-pathways-dojo"
}
