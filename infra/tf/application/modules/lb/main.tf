resource "aws_lb" "this" {
  name_prefix                = var.resource_name_prefix
  load_balancer_type         = "application"
  subnets                    = var.lb_subnets
  security_groups            = [aws_security_group.lb.id]
  internal                   = false
  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = var.tags

  # make use of the cert to encrypt https traffic
  certificate_arn = var.aws_acm_certificate_validation_arn
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  # name prefix is used because when applying changes to the target group, it often errors since ecs is still using it,
  # in combination with create_before_destroy, this allows it to be switched out without running into the issue since ecs will switch to the new one before destroy
  name_prefix = var.resource_name_prefix
  protocol    = "HTTP"
  port        = var.default_port
  vpc_id      = var.vpc_id
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

