variable "resource_name_prefix" {
  type    = string
  default = "lj-pathways-dojo"
}

variable "additional_tags" {
  default = {}
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.0.1.192/28", "10.0.1.208/28", "10.0.1.224/28"]
}

variable "vpc_private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}

variable "s3_gateway_endpoint" {
  type    = string
  default = "com.amazonaws.ap-southeast-2.s3"
}

variable "s3_bucket_name" {
  type    = string
  default = "lj-pathways-dojo"
}
