variable "bucket" {
  type        = string
  description = "Specifies the name of an S3 Bucket"
  default     = "lj-weather-app"
}

variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default = {
    Name = "lj-weather-app"
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "Specifies the availability zones for the project"
  default     = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}

variable "app_name" {
  type        = string
  description = "name of the application for tagging resources"
  default     = "lj-weather-app"
}

variable "region" {
  type        = string
  description = "the region to connect to"
  default     = "ap-southeast-2"
}
