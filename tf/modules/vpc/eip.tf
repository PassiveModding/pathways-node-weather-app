resource "aws_eip" "this" {
  count = length(aws_subnet.public)
  vpc   = true
  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}_eip${count.index}"
    },
  )
}
