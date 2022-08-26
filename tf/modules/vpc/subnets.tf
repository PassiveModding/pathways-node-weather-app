resource "aws_subnet" "public" {
  count  = length(data.aws_availability_zones.this.names)
  vpc_id = aws_vpc.this.id
  # shift this space to account for up to 3 /26 subnets. This should start at x.x.x.192
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 4, count.index + 12)
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}_public${count.index}"
    },
  )
}

resource "aws_subnet" "private" {
  count                   = length(data.aws_availability_zones.this.names)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 2, count.index)
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}_private${count.index}"
    },
  )
}

