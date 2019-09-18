resource "aws_lb" "alb" {
  name            = "vault-${var.environment}-${var.project}-alb"
  internal        = var.lb_internal
  subnets         = var.lb_subnets
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "main" {
  name     = "vault-main-${var.environment}-${var.project}"
  port     = 8200
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    matcher           = 200
    protocol          = "HTTPS"
    path              = "/v1/sys/health"
    healthy_threshold = 4
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.acm_arn

  default_action {
    target_group_arn = aws_lb_target_group.main.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "vault1" {
  name     = "vault1-${var.environment}-${var.project}"
  port     = 8200
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    matcher           = "404"
    protocol          = "HTTPS"
    path              = "/"
    healthy_threshold = 4
  }
}

resource "aws_lb_target_group_attachment" "vault1" {
  target_group_arn = aws_lb_target_group.vault1.arn
  target_id        = module.vault1.instance_ids[0]
  port             = 8200
}

resource "aws_lb_listener_rule" "vault1" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault1.arn
  }

  condition {
    field  = "host-header"
    values = [aws_route53_record.vault1.name]
  }
}

resource "aws_lb_target_group" "vault2" {
  name     = "vault2-${var.environment}-${var.project}"
  port     = 8200
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    matcher           = "404"
    protocol          = "HTTPS"
    path              = "/"
    healthy_threshold = 4
  }
}

resource "aws_lb_target_group_attachment" "vault2" {
  target_group_arn = aws_lb_target_group.vault2.arn
  target_id        = module.vault2.instance_ids[0]
  port             = 8200
}

resource "aws_lb_listener_rule" "vault2" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 11

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault2.arn
  }

  condition {
    field  = "host-header"
    values = [aws_route53_record.vault2.name]
  }
}

resource "aws_lb_target_group_attachment" "vault1_main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = module.vault1.instance_ids[0]
  port             = 8200
}

resource "aws_lb_target_group_attachment" "vault2_main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = module.vault2.instance_ids[0]
  port             = 8200
}
