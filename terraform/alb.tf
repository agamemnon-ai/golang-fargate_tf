#-----------------------------------------------------------------
# ALB
#-----------------------------------------------------------------

resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1c.id]

  tags = {
    Name    = "${var.project}-${var.environment}-alb"
    Project = var.project
    Env     = var.environment
  }
}

#-----------------------------------------------------------------
# Listener
#-----------------------------------------------------------------

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

#-----------------------------------------------------------------
# Target Group
#-----------------------------------------------------------------

resource "aws_lb_target_group" "target_group" {
  name        = "${var.project}-${var.environment}-alb-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold = 3
    interval          = 30
    path              = "/root.html"
    protocol          = "HTTP"
    timeout           = 5
  }
}