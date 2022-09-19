# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name           = var.ssm_resource_prefix
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
  tags                   = var.tags
  enable_dns_support     = true
  enable_dns_hostnames   = true
}

module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.s3_bucket_name
  tags   = var.tags
}


# S3 Endpoint
data "aws_iam_policy_document" "set_gateway_endpoint_policy_document" {
  statement {
    sid = "${var.ssm_resource_prefix}-bucket-policy"
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
      "${module.s3_bucket.s3_bucket_arn}/*",
      # starport layer access required to allow ecs to access the ecr repo
      # consider: could this be moved to the app layer
      "arn:aws:s3:::prod-${data.aws_region.current.name}-starport-layer-bucket/*",
      "arn:aws:s3:::prod-${data.aws_region.current.name}-starport-layer-bucket"
    ]
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  policy            = data.aws_iam_policy_document.set_gateway_endpoint_policy_document.json
  vpc_endpoint_type = "Gateway"
  tags              = var.tags
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

data "aws_region" "current" {}
