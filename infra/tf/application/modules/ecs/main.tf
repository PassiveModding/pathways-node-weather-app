resource "aws_ecs_cluster" "this" {
  name = "${var.resource_name_prefix}-cluster"

  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name            = "${var.resource_name_prefix}-ecs"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = var.ecs_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "${var.resource_name_prefix}-container"
    container_port   = var.container_port
  }

  tags = var.tags
}

data "aws_ecr_repository" "this" {
  name = var.ecr_name
}

resource "aws_ecs_task_definition" "this" {
  network_mode             = "awsvpc"
  family                   = "${var.resource_name_prefix}-family"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution.arn
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode(
    [
      {
        name      = "${var.resource_name_prefix}-container",
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
