module "alb" {
  source                       = "github.com/skyscrapers/terraform-loadbalancers//alb?ref=3.1.2"
  name                         = "vault"
  environment                  = "${var.environment}"
  project                      = "${var.project}"
  vpc_id                       = "${var.vpc_id}"
  subnets                      = "${var.lb_subnets}"
  enable_http_listener         = false
  enable_https_listener        = true
  https_certificate_arn        = "${var.acm_arn}"
  target_security_groups       = ["${aws_security_group.vault.id}"]
  target_port                  = 8200
  target_protocol              = "HTTPS"
  target_health_path           = "/v1/sys/health"
  target_health_protocol       = "HTTPS"
  target_security_groups_count = 1
  internal                     = "${var.lb_internal}"

  target_stickiness = [{
    enabled = false
    type    = "lb_cookie"
  }]
}

resource "aws_lb_target_group" "vault1" {
  name     = "vault1-group"
  port     = 8200
  protocol = "HTTPS"
  vpc_id   = "${var.vpc_id}"

  stickiness = {
    enabled = false
    type    = "lb_cookie"
  }

  health_check = {
    matcher  = "404"
    protocol = "HTTPS"
    path     = "/"
  }
}

resource "aws_lb_target_group_attachment" "vault1" {
  target_group_arn = "${aws_lb_target_group.vault1.arn}"
  target_id        = "${module.vault1.instance_ids[0]}"
  port             = 8200
}

resource "aws_lb_listener_rule" "vault1" {
  listener_arn = "${module.alb.https_listener_id}"
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.vault1.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.vault1.name}"]
  }
}

resource "aws_lb_target_group" "vault2" {
  name     = "vault2-group"
  port     = 8200
  protocol = "HTTPS"
  vpc_id   = "${var.vpc_id}"

  stickiness = {
    enabled = false
    type    = "lb_cookie"
  }

  health_check = {
    matcher  = "404"
    protocol = "HTTPS"
    path     = "/"
  }
}

resource "aws_lb_target_group_attachment" "vault2" {
  target_group_arn = "${aws_lb_target_group.vault2.arn}"
  target_id        = "${module.vault2.instance_ids[0]}"
  port             = 8200
}

resource "aws_lb_listener_rule" "vault2" {
  listener_arn = "${module.alb.https_listener_id}"
  priority     = 11

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.vault2.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${aws_route53_record.vault2.name}"]
  }
}

resource "aws_lb_target_group_attachment" "vault1_main" {
  target_group_arn = "${module.alb.target_group_arn}"
  target_id        = "${module.vault1.instance_ids[0]}"
  port             = 8200
}

resource "aws_lb_target_group_attachment" "vault2_main" {
  target_group_arn = "${module.alb.target_group_arn}"
  target_id        = "${module.vault2.instance_ids[0]}"
  port             = 8200
}
