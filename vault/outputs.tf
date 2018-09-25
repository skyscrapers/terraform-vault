output "sg_id" {
  description = "The vault security-group id"
  value       = "${aws_security_group.vault.id}"
}

output "vault_route53_record" {
  description = "The main vault route53 record id"
  value       = "${aws_route53_record.vault.id}"
}

output "vault1_route53_record" {
  description = "The vault1 route53 record id"
  value       = "${aws_route53_record.vault1.id}"
}

output "vault2_route53_record" {
  description = "The vault2 route53 record id"
  value       = "${aws_route53_record.vault1.id}"
}

output "vault1_instance_id" {
  description = "The vault1 instance ID"
  value       = "${module.vault1.instance_ids[0]}"
}

output "vault2_instance_id" {
  description = "The vault2 instance ID"
  value       = "${module.vault2.instance_ids[0]}"
}

output "vault1_role_id" {
  description = "The vault1 instance-role ID"
  value       = "${module.vault1.role_id}"
}

output "vault1_role_name" {
  description = "The vault1 instance-role name"
  value       = "${module.vault1.role_name}"
}

output "vault2_role_id" {
  description = "The vault2 instance-role ID"
  value       = "${module.vault2.role_id}"
}

output "vault2_role_name" {
  description = "The vault2 instance-role name"
  value       = "${module.vault2.role_name}"
}

output "iam_policy" {
  description = "The iam policy ARN used for vault"
  value       = "${aws_iam_policy.vault.arn}"
}

output "alb_main_target_group" {
  description = "The default alb target group ARN"
  value       = "${module.alb.target_group_arn}"
}

output "alb_vault1_target_group" {
  description = "The vault1 target group ARN"
  value       = "${aws_lb_target_group.vault1.arn}"
}

output "alb_vault2_target_group" {
  description = "The vault2 target group ARN"
  value       = "${aws_lb_target_group.vault2.arn}"
}

output "alb_sg_id" {
  description = "The alb security group ID"
  value       = "${module.alb.sg_id}"
}

output "alb_id" {
  description = "The alb id"
  value       = "${module.alb.id}"
}

output "alb_arn" {
  description = "The alb ARN"
  value       = "${module.alb.arn}"
}

output "dynamodb_table_name" {
  description = "The Vault dynamodb table name"
  value       = "${local.dynamodb_table_name}"
}

output "main_dynamodb_table_region" {
  description = "Region where the main DynamoDB table will be created"
  value       = "${data.aws_region.main.name}"
}

output "replica_dynamodb_table_region" {
  description = "Region where the replica DynamoDB table will be created, if enabled"
  value       = "${data.aws_region.replica.name}"
}
