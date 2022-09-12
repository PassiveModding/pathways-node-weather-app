output "aws_region" {
  value       = data.aws_region.current.name
  description = "the region which the vpc is deployed"
}

output "aws_vpc_id" {
  value       = module.vpc.vpc_id
  description = "the id of the vpc which"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnets[*]
  description = "the ids of each public subnet"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnets[*]
  description = "the ids of each private subnet"
}


resource "aws_ssm_parameter" "region" {
  name  = "/${var.ssm_resource_prefix}/vpc/region"
  type  = "String"
  value = data.aws_region.current.name
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.ssm_resource_prefix}/vpc/id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  count = length(module.vpc.public_subnets)
  name  = "/${var.ssm_resource_prefix}/subnet/public/${count.index}/id"
  type  = "String"
  value = module.vpc.public_subnets[count.index]
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  count = length(module.vpc.private_subnets)
  name  = "/${var.ssm_resource_prefix}/subnet/private/${count.index}/id"
  type  = "String"
  value = module.vpc.private_subnets[count.index]
}
