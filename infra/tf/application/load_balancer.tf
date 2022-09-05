resource "aws_lb" "this" {
  name               = "${var.app_name}-load-balancer"
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
  name = "${var.app_name}-lb-target-group"
  # the port in the target group is the port on which all targets receive traffic
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  target_type = "ip"
  /*
  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
*/
  tags = var.tags
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}
