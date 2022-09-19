# allow http/https requests but nothing else
resource "aws_security_group" "lb" {
  name   = "${var.resource_name_prefix}-lb-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    description      = "http"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    description      = "https"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    ignore_changes = [tags, tags_all]
  }
}
