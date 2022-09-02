data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.resource_name_prefix}/vpc/id"
}

data "aws_ssm_parameter" "ecr_name" {
  name = "/${var.resource_name_prefix}/ecr/name"
}

data "aws_ecr_repository" "this" {
  name = data.aws_ssm_parameter.ecr_name.value
}

# select public and private subnets randomly but make sure both public and private are paired in the same az
data "aws_availability_zones" "this" {}

# technically could fail if only 1 public subnet is available?
resource "random_shuffle" "random_az" {
  input        = data.aws_availability_zones.this.names
  result_count = 2
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }

  filter {
    name   = "availability-zone"
    values = random_shuffle.random_az.result
  }

  tags = {
    is_public = "true"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }

  filter {
    name   = "availability-zone"
    values = random_shuffle.random_az.result
  }
  tags = {
    is_public = "false"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${var.app_name}-cluster"

  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name                               = "${var.app_name}-ecs"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  scheduling_strategy                = "REPLICA"
  launch_type                        = "FARGATE"
  force_new_deployment               = true

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = data.aws_subnets.private.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  tags = var.tags
}

resource "aws_ecs_task_definition" "this" {
  network_mode             = "awsvpc"
  family                   = var.app_name
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution.arn
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode(
    [
      {
        name      = var.app_name,
        image     = "${data.aws_ecr_repository.this.repository_url}:latest",
        essential = true,
        cpu       = 0,
        portMappings = [
          {
            protocol      = "tcp",
            containerPort = var.container_port,
            hostPoty      = var.container_port
          }
        ],
        logConfigurations = {
          logDriver = "awslogs",
          options = {
            awslogs-group  = "${aws_cloudwatch_log_group.this.name}",
            awslogs-region = "${data.aws_ssm_parameter.vpc_region.value}"
          }
        }
      }
  ])

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "this" {
  name = var.app_name
}
