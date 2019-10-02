locals {
  security_groups = compact([aws_security_group.vault.id, var.teleport_node_sg])
}

module "vault1" {
  source        = "github.com/skyscrapers/terraform-instances//instance?ref=3.0.2"
  project       = var.project
  environment   = var.environment
  name          = "vault1"
  sgs           = local.security_groups
  subnets       = [var.vault1_subnet]
  key_name      = var.key_name
  ami           = var.ami
  instance_type = var.instance_type
  user_data     = [data.template_cloudinit_config.vault1.rendered]
  cpu_credits   = var.ec2_instances_cpu_credits
}

module "vault2" {
  source        = "github.com/skyscrapers/terraform-instances//instance?ref=3.0.2"
  project       = var.project
  environment   = var.environment
  name          = "vault2"
  sgs           = local.security_groups
  subnets       = [var.vault2_subnet]
  key_name      = var.key_name
  ami           = var.ami
  instance_type = var.instance_type
  user_data     = [data.template_cloudinit_config.vault2.rendered]
  cpu_credits   = var.ec2_instances_cpu_credits
}
