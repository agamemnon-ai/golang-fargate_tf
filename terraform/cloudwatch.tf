#-----------------------------------------------------------------
# IAM Role for ECS
#-----------------------------------------------------------------

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/ecs/${var.project}-${var.environment}"
  retention_in_days = 1
}