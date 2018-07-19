data "aws_route53_zone" "root" {
  name = "${var.dns_root}"
}

resource "aws_route53_record" "vault" {
  zone_id = "${data.aws_route53_zone.root.zone_id}"
  name    = "vault.${data.aws_route53_zone.root.name}"
  type    = "A"

  alias {
    name                   = "${module.alb.dns_name}"
    zone_id                = "${module.alb.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "vault1" {
  zone_id = "${data.aws_route53_zone.root.zone_id}"
  name    = "vault1.${data.aws_route53_zone.root.name}"
  type    = "A"

  alias {
    name                   = "${module.alb.dns_name}"
    zone_id                = "${module.alb.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "vault2" {
  zone_id = "${data.aws_route53_zone.root.zone_id}"
  name    = "vault2.${data.aws_route53_zone.root.name}"
  type    = "A"

  alias {
    name                   = "${module.alb.dns_name}"
    zone_id                = "${module.alb.zone_id}"
    evaluate_target_health = false
  }
}
