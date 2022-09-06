resource "aws_lb" "this" {
  name_prefix        = var.resource_name_prefix
  load_balancer_type = "application"
  # must be over 2 of the public subnets
  subnets         = data.aws_subnets.public.ids
  security_groups = [aws_security_group.lb.id]

  internal                   = false
  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  # name prefix is used because when applying changes to the target group, it often errors since ecs is still using it,
  # in combination with create_before_destroy, this allows it to be switched out without running into the issue since ecs will switch to the new one before destroy
  name_prefix = var.resource_name_prefix
  # the port in the target group is the port on which all targets receive traffic
  # NOTE: since the ecs service itself registers it's port, this is unused.
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "aws_lb_url" {
  value = aws_lb.this.dns_name
}
