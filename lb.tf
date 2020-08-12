resource "aws_lb" "Monoprod" {
  name               = "Monoprod-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["aws_security_group.allow443.id", "aws_security_group.allow80.id", "aws_security_group.Mono_Instances"]
  subnets            = ["aws_subnet.public.*.id"]

  enable_deletion_protection = true


  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.Monoprod.arn
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
}

resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn = aws_lb.Monoprod.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "arn:aws:acm:eu-west-2:221124075124:certificate/3bfb830a-6c27-43cb-b5ba-0ba84d48285c"

  default_action {
    type             = "forward"
    target_group_arn = "aws_lb_target_group.Monolaunch-TG.arn"
  }
}

resource "aws_lb_target_group" "Monolaunch-TG" {
  name     = "Monoprod-TG"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.vpc_dev.id

  health_check {
    path = "/"
    port = 80
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 10
    matcher = "200-302"
  }
}

resource "aws_lb" "Swarm-Internal-LB" {
  name               = "Swarm-Internal-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["aws_security_group.Mono_Swarm_Node_SG.id", "aws_security_group.Mono_Swarm_Internal_LB_SG.id"]
  subnets            = ["aws_subnet.public.*.id"]

  enable_deletion_protection = true


  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "HTTPS_Swarm" {
  load_balancer_arn = aws_lb.Swarm-Internal-LB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "arn:aws:acm:eu-west-2:221124075124:certificate/3bfb830a-6c27-43cb-b5ba-0ba84d48285c"

  default_action {
    type             = "forward"
    target_group_arn = "aws_lb_target_group.Swarm_Internal_TG.arn"
  }
}

resource "aws_lb_target_group" "Swarm_Internal_TG" {
  name     = "Swarm-Internal-TG"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.vpc_dev.id

  health_check {
    path = "/"
    port = 80
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = "200-404"
  }
}