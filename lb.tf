data "aws_acm_certificate" "salary_finance" {
  domain = "salaryfinance.club"
}

resource "aws_lb" "monoprod_lb" {
  name               = "monoprod-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_https.id, aws_security_group.allow_http.id, aws_security_group.monolaunch_instance_sg.id]
  subnets            = [aws_subnet.public_subnet_b.id, aws_subnet.public_subnet_a.id]

  enable_deletion_protection = true
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.monoprod_lb.arn
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

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.monoprod_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = data.aws_acm_certificate.salary_finance.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.monoprod_tg.arn
  }
}

resource "aws_lb_target_group" "monoprod_tg" {
  name     = "monoprod-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.vpc_prod_us.id

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

resource "aws_lb" "swarm_internal_lb" {
  name               = "swarm-internal-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.swarm_node_sg.id, aws_security_group.swarm_internal_lb_sg.id]
  subnets            = [aws_subnet.public_subnet_b.id, aws_subnet.public_subnet_a.id]

  enable_deletion_protection = true

}

resource "aws_lb_listener" "https_swarm" {
  load_balancer_arn = aws_lb.swarm_internal_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = data.aws_acm_certificate.salary_finance.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.swarm_internal_tg.arn
  }
}

resource "aws_lb_target_group" "swarm_internal_tg" {
  name     = "swarm-internal-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.vpc_prod_us.id

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