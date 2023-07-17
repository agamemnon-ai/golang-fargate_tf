#-----------------------------------------------------------------
# Value of Farage App
#-----------------------------------------------------------------

resource "aws_ssm_parameter" "app_cpu" {
  name  = "/${var.project}/application/fargate/app/cpu"
  type  = "SecureString"
  value = "256"
}

resource "aws_ssm_parameter" "app_memory" {
  name  = "/${var.project}/application/fargate/app/memory"
  type  = "SecureString"
  value = "512"
}

resource "aws_ssm_parameter" "app_desired_count" {
  name  = "/${var.project}/application/fargate/app/desired_count"
  type  = "SecureString"
  value = "2"
}

resource "aws_ssm_parameter" "app_deployment_minimum_healthy_percent" {
  name  = "/${var.project}/application/fargate/app/deployment_minimum_healthy_percent"
  type  = "SecureString"
  value = "100"
}

resource "aws_ssm_parameter" "app_deployment_maximum_percent" {
  name  = "/${var.project}/application/fargate/app/deployment_maximum_percent"
  type  = "SecureString"
  value = "200"
}

resource "aws_ssm_parameter" "app_healthcheck_period" {
  name  = "/${var.project}/application/fargate/app/healthcheck_period"
  type  = "SecureString"
  value = "180"
}

resource "aws_ssm_parameter" "app_env1" {
  name  = "/${var.project}/application/fargate/app/env1"
  type  = "SecureString"
  value = "xxxxxxxxx"
}

resource "aws_ssm_parameter" "app_env2" {
  name  = "/${var.project}/application/fargate/app/env2"
  type  = "SecureString"
  value = "xxxxxxxxxx"
}