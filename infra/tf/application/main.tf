data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.ssm_resource_prefix}/vpc/id"
}

data "aws_ssm_parameter" "ecr_name" {
  name = "/${var.ssm_resource_prefix}/ecr/name"
}

data "aws_ssm_parameter" "region" {
  name = "/${var.ssm_resource_prefix}/vpc/region"
}
# select public and private subnets randomly but make sure both public and private are paired in the same az
data "aws_availability_zones" "this" {}

# technically could fail if only 1 public subnet is available?
resource "random_shuffle" "random_az" {
  input        = data.aws_availability_zones.this.names
  result_count = 2
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }

  filter {
    name   = "availability-zone"
    values = random_shuffle.random_az.result
  }

  tags = {
    is_public = "true"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }

  filter {
    name   = "availability-zone"
    values = random_shuffle.random_az.result
  }
  tags = {
    is_public = "false"
  }
}

#############
# Modules
#############
module "dns" {
  source              = "./modules/dns"
  route53_domain_base = var.route53_domain_base
  route53_domain_name = var.route53_domain_name
}

module "ecs" {
  source                      = "./modules/ecs"
  lb_target_group_arn         = module.lb.target_group_arn
  resource_name_prefix        = var.resource_name_prefix
  ecr_name                    = data.aws_ssm_parameter.ecr_name.value
  tags                        = var.tags
  container_port              = var.container_port
  ecs_ingress_security_groups = [module.lb.lb_security_group_id]
  vpc_id                      = data.aws_ssm_parameter.vpc_id.value
  ecs_subnets                 = data.aws_subnets.private.ids
  region                      = data.aws_ssm_parameter.region.value
}

module "lb" {
  source                             = "./modules/lb"
  vpc_id                             = data.aws_ssm_parameter.vpc_id.value
  aws_acm_certificate_validation_arn = module.dns.validation_certificate_arn
  lb_subnets                         = data.aws_subnets.public.ids
  resource_name_prefix               = var.resource_name_prefix
  tags                               = var.tags
  default_port                       = var.container_port
}

#######
