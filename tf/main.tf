module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.bucket

  tags = var.tags
}

module "vpc" {
  source             = "./modules/vpc"
  tags               = var.tags
  availability_zones = var.availability_zones
  app_name           = var.app_name
  region             = var.region
}

output "bucket_name" {
  description = "The name of the bucket"
  value       = module.s3_bucket.s3_bucket_name
}

output "bucket_name_arn" {
  description = "The name of the bucket"
  value       = module.s3_bucket.s3_bucket_name_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnet
}

output "private_subnets" {
  value = module.vpc.private_subnet
}

output "nat_gateway" {
  value = module.vpc.nat_gateway
}

output "internet_gateway" {
  value = module.vpc.internet_gateway
}

output "nat_eips" {
  value = module.vpc.nat_ips
}
