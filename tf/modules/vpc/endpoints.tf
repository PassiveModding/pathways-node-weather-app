resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${var.region}.s3"

  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}_s3_endpoint"
    },
  )
}

resource "aws_vpc_endpoint_route_table_association" "s3_association" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_vpc.this.default_route_table_id
}
