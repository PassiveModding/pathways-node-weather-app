# 1 * Virtual Private Cloud (VPC): (/24)
resource "aws_vpc" "this" {
  cidr_block = "10.0.1.0/24"

  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}_vpc"
    },
  )
}

# get az's from the provider region
data "aws_availability_zones" "this" {
}

# Internet Gateway (IGW): VPC Attached
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

    tags = merge(
    var.tags,
    {
      Name = "${var.app_name}_igw"
    },
  )
}
