resource "aws_security_group" "vault" {
  name_prefix = "vault_${var.project}_"
  description = "vault specific rules"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "vault_from_alb" {
  type                     = "ingress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  source_security_group_id = "${module.alb.sg_id}"
  security_group_id        = "${aws_security_group.vault.id}"
}

resource "aws_security_group_rule" "vault_from_self" {
  type              = "ingress"
  from_port         = 8200
  to_port           = 8201
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.vault.id}"
}

resource "aws_security_group_rule" "vault_to_world" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.vault.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
