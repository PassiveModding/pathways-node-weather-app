data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.ssm_resource_prefix}/vpc/id"
}

data "aws_ssm_parameter" "ecr_name" {
  name = "/${var.ssm_resource_prefix}/ecr/name"
}

data "aws_ecr_repository" "this" {
  name = data.aws_ssm_parameter.ecr_name.value
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

resource "aws_cloudwatch_log_group" "this" {
  name_prefix = var.resource_name_prefix
}
