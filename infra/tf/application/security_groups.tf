# allow http/https requests but nothing else
resource "aws_security_group" "lb" {
  name   = "${var.app_name}-alb-sg"
  vpc_id = data.aws_ssm_parameter.vpc_id.value

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

# security group for the containers to only allow inbound traffic from the load balancer
resource "aws_security_group" "ecs" {
  name   = "${var.app_name}-ecs-sg"
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  /*
  ingress {
    protocol        = "tcp"
    description     = "http"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    protocol        = "tcp"
    description     = "https"
    from_port       = 443
    to_port         = 443
    security_groups = [aws_security_group.lb.id]
  }
  */

  ingress {
    protocol        = "tcp"
    description     = "container"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = [aws_security_group.lb.id]
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
