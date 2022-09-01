# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name           = var.resource_name_prefix
  cidr           = var.vpc_cidr
  public_subnets = var.vpc_public_subnets
  public_subnet_tags = {
    "is_public" = "true"
  }
  private_subnets = var.vpc_private_subnets
  private_subnet_tags = {
    "is_public" = "false"
  }
  azs                    = var.availability_zones
  create_igw             = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  tags                   = var.additional_tags
}

module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.s3_bucket_name
  tags   = var.additional_tags
}


# S3 Endpoint
data "aws_iam_policy_document" "set_gateway_endpoint_policy_document" {
  statement {
    sid = "${var.resource_name_prefix}-bucket-policy"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "${module.s3_bucket.s3_bucket_arn}",
      "${module.s3_bucket.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = var.s3_gateway_endpoint
  policy            = data.aws_iam_policy_document.set_gateway_endpoint_policy_document.json
  vpc_endpoint_type = "Gateway"
  tags              = var.additional_tags
}

resource "aws_vpc_endpoint_route_table_association" "public_s3_association" {
  count           = length(module.vpc.public_route_table_ids)
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = module.vpc.public_route_table_ids[count.index]
}

resource "aws_vpc_endpoint_route_table_association" "private_s3_association" {
  count           = length(module.vpc.private_route_table_ids)
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = module.vpc.private_route_table_ids[count.index]
}


#########################
## Outputs
#########################

#########################
## SSM Parameter outputs
#########################
data "aws_region" "current" {}
resource "aws_ssm_parameter" "region" {
  name  = "/${var.resource_name_prefix}/vpc/region"
  type  = "String"
  value = data.aws_region.current.name
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.resource_name_prefix}/vpc/id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  count = length(module.vpc.public_subnets)
  name  = "/${var.resource_name_prefix}/subnet/public/${count.index}/id"
  type  = "String"
  value = module.vpc.public_subnets[count.index]
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  count = length(module.vpc.private_subnets)
  name  = "/${var.resource_name_prefix}/subnet/private/${count.index}/id"
  type  = "String"
  value = module.vpc.private_subnets[count.index]
}
