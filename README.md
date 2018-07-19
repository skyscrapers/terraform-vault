# Terraform Vault

Terraform module(s) to setup Vault on AWS

## Vault

This terraform module sets up a HA vault with a DynamoDB backend.
The module sets up TLS using Letsencrypt with dns-01 challenge.

Both vault servers are optionally configured with Teleport for SSH management.

Two route53 records are provided to access the individual instances.

![](vault/images/vault-component.svg)

### Available variables

* [`acm_arn`]: String(required): The ACM ARN to use on the alb
* [`ami`]: String(required): The AMI ID to use for the vault instances
* [`dns_root`]: String(required): The root domain to configure for vault
* [`lb_subnets`]: List(required): The subnets to use for the alb
* [`key_name`]: String(required): Name of the sshkey to deploy on the vault instances
* [`teleport_auth_server`]: String(optional): The hostname or ip of the Teleport auth server. If empty, Teleport integration will be disabled (default).
* [`teleport_node_sg`]: String(optional): The security-group ID of the teleport server.
* [`teleport_token_1`]: String(optional): The Teleport token for the first instance. This can be a dynamic short-lived token.
* [`teleport_token_2`]: String(optional): The Teleport token for the second instance. This can be a dynamic short-lived token.
* [`vault1_subnet`]: String(required): The subnet ID for the first vault instance
* [`vault2_subnet`]: String(required): The subnet ID for the second vault instance
* [`vpc_id`]: String(required): The VPC id to launch the instances in.

* [`download_url_vault`]: String(optional): The download url for vault. Defaults to `https://releases.hashicorp.com/vault/0.9.0/vault_0.9.0_linux_amd64.zip`
* [`download_url_teleport`]: String(optional): The download url for Teleport. Defaults to `https://github.com/gravitational/teleport/releases/download/v2.3.5/teleport-v2.3.5-linux-amd64-bin.tar.gz`
* [`instance_type`]: String(optional): The instance type to use for the vault servers. Defaults to t2.micro
* [`lb_internal`]: Bool(optional): Should the ALB be created as an internal Loadbalancer
* [`project`]: String(required): Name of the project
* [`environment`]: String(required): Name of the environment where to deploy Vault (just for naming reasons)
* [`vault_nproc`]: String(optional): The amount of nproc to configure vault with. Set this to the amount of CPU cores. Defaults to 1

### Output

* [`sg_id`]: String: The vault security-group id
* [`vault_route53_record`]: String: The main vault route53 record id
* [`vault1_route53_record`]: String: The vault1 route53 record id
* [`vault2_route53_record`]: String: The vault2 route53 record id
* [`vault1_instance_id`]: String: The vault1 instance ID
* [`vault2_instance_id`]: String: The vault2 instance ID
* [`vault1_role_id`]: String: The vault1 instance-role ID
* [`vault1_role_name`]: String: The vault1 instance-role name
* [`vault2_role_id`]: String: The vault2 instance-role ID
* [`vault2_role_name`]: String: The vault2 instance-role name
* [`iam_policy`]: String: The iam policy ARN used for vault
* [`alb_main_target_group`]: String: The default alb target group ARN
* [`alb_vault1_target_group`]: String: The vault1 target group ARN
* [`alb_vault2_target_group`]: String: The vault2 target group ARN
* [`alb_sg_id`]: String: The alb security group ID
* [`alb_id`]: String: The alb id
* [`alb_arn`]: String: The alb ARN

### Example

```terraform
module "ha_vault" {
  source               = "github.com/skyscrapers/terraform-vault//vault?ref=1.0.0"
  teleport_auth_server = "10.10.0.100:3025"
  ami                  = "ami-add175d4"
  project              = "whatever"
  vault1_subnet        = "${data.terraform_remote_state.static.private_app_subnets[0]}"
  vault2_subnet        = "${data.terraform_remote_state.static.private_app_subnets[1]}"
  teleport_node_sg     = "${data.terraform_remote_state.static.teleport_node_sg_id}"
  vpc_id               = "${data.terraform_remote_state.static.vpc_id}"
  lb_subnets           = "${data.terraform_remote_state.static.public_lb_subnets}"
  acm_arn              = "${data.aws_acm_certificate.vault.arn}"
  teleport_token_1     = "c010f4fa754b7ad2a7a1d580e282d81b"
  teleport_token_2     = "6b69a780b9137g467f79ab7263337fd6"
  dns_root             = "${var.dns_root}"
  vault_nproc          = "2"
  key_name             = "sam"
}
```
