output "sg_id" {
  value = "${aws_security_group.vault.id}"
}

output "vault_route53_record" {
  value = "${aws_route53_record.vault.id}"
}

output "vault1_route53_record" {
  value = "${aws_route53_record.vault1.id}"
}

output "vault2_route53_record" {
  value = "${aws_route53_record.vault1.id}"
}

output "vault1_instance_id" {
  value = "${module.vault1.instance_ids[0]}"
}

output "vault2_instance_id" {
  value = "${module.vault2.instance_ids[0]}"
}

output "vault1_role_id" {
  value = "${module.vault1.role_id}"
}

output "vault1_role_name" {
  value = "${module.vault1.role_name}"
}

output "vault2_role_id" {
  value = "${module.vault2.role_id}"
}

output "vault2_role_name" {
  value = "${module.vault2.role_name}"
}

output "iam_policy" {
  value = "${aws_iam_policy.vault.arn}"
}

output "alb_main_target_group" {
  value = "${module.alb.target_group_arn}"
}

output "alb_vault1_target_group" {
  value = "${aws_lb_target_group.vault1.arn}"
}

output "alb_vault2_target_group" {
  value = "${aws_lb_target_group.vault2.arn}"
}

output "alb_sg_id" {
  value = "${module.alb.sg_id}"
}

output "alb_id" {
  value = "${module.alb.id}"
}

output "alb_arn" {
  value = "${module.alb.arn}"
}
