variable "repo_name" {
  type        = string
  default     = "lj-weather-app"
  description = "name of the repo to be created"
}

variable "tags" {
  default     = {}
  description = "additional tags for the repository resource"
}

variable "ssm_resource_prefix" {
  type        = string
  default     = "lj-pathways-dojo"
  description = "first path structure section for ssm resources"
}
