resource "aws_ecs_cluster" "this" {
  name = "${var.app_name}-cluster"

  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name            = "${var.app_name}-ecs"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = data.aws_subnets.private.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "${var.app_name}-container"
    container_port   = var.container_port
  }

  tags = var.tags
}

resource "aws_ecs_task_definition" "this" {
  network_mode             = "awsvpc"
  family                   = "${var.app_name}-family"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution.arn
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode(
    [
      {
        name      = "${var.app_name}-container",
        image     = "${data.aws_ecr_repository.this.repository_url}:latest",
        essential = true,
        cpu       = 0,
        portMappings = [
          {
            protocol      = "tcp",
            containerPort = "${var.container_port}"
          }
        ]
      }
  ])

  tags = var.tags
}
