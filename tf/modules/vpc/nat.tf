resource "aws_nat_gateway" "public" {
  count         = length(aws_subnet.public)
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.this[count.index].id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}_public_nat${count.index}"
    },
  )
}
