
# security group for the containers to only allow inbound traffic from the load balancer
resource "aws_security_group" "ecs" {
  name   = "${var.resource_name_prefix}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol        = "tcp"
    description     = "container"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = var.ecs_ingress_security_groups
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
