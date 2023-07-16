#-----------------------------------------------------------------
# Task Definition
#-----------------------------------------------------------------

resource "aws_ecs_task_definition" "app_def" {
  family                   = "${var.project}-${var.environment}-app-def"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs.arn

  container_definitions = <<JSON
  [
    {
      "name": "${var.project}-${var.environment}",
      "image": "${var.account}.dkr.ecr.us-east-1.amazonaws.com/golang-fargate_tf:latest",
      "essential": true,
      "cpu": 256,
      "portMappings": [
        {
          "containerPort": 8080
        }
      ],
      "environment" : [
        {
          "name": "ENV1",
          "value": "Good Morning"
        },
        {
          "name": "ENV2",
          "value": "Good Afternoon"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.cloudwatch_log_group.name}",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
    JSON
}

#-----------------------------------------------------------------
# ECS Cluster
#-----------------------------------------------------------------
resource "aws_ecs_cluster" "test-cluster" {
  name = "${var.project}-${var.environment}-test-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "test_cluster_providers" {
  cluster_name       = aws_ecs_cluster.test-cluster.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}


#-----------------------------------------------------------------
# ECS Service
#-----------------------------------------------------------------

resource "aws_ecs_service" "test_service" {
  name            = "${var.project}-${var.environment}-test-service"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.test-cluster.id
  task_definition = aws_ecs_task_definition.app_def.arn
  platform_version = "1.4.0"
  desired_count   = 2
  deployment_minimum_healthy_percent  = 100
  deployment_maximum_percent = 200
  health_check_grace_period_seconds = 120
  network_configuration {
    subnets         = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.project}-${var.environment}"
    container_port   = 8080
  }
}