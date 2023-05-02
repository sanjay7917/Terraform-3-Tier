#NGINX LOAD BALANCER
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  load_balancer_type = "application"
  internal = false
  security_groups    = [var.vpc_security_group_ids]
  subnets            = var.pub_sub_ids
  tags               = var.nginx_alb_tags
}
resource "aws_lb_listener" "nginx_alb_lis" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_alb_tg.arn
  }
}
resource "aws_lb_target_group" "nginx_alb_tg" {
  name     = "nginx-alb-tg"
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
    port                = 80
  }
}

#TOMCAT LOAD BALANCER
resource "aws_lb" "tomcat_alb" {
  name               = "tomcat-alb"
  load_balancer_type = "application"
  internal = true
  security_groups    = [var.vpc_security_group_ids]
  subnets            = [var.pri_sub_ids[0], var.pri_sub_ids[1]]
  enable_deletion_protection = false

  tags               = var.tomcat_alb_tags
}
resource "aws_lb_listener" "tomcat_alb_lis" {
  load_balancer_arn = aws_lb.tomcat_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tomcat_alb_tg.arn
  }
}
resource "aws_lb_target_group" "tomcat_alb_tg" {
  name     = "tomcat-alb-tg"
  vpc_id   = var.vpc_id
  port     = 8080
  protocol = "HTTP"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
  }
}

