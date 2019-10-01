provider "aws" {
}

provider "aws" {
  alias  = "replica"
  region = var.dynamodb_replica_region
}

# Get the latest ubuntu ami
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_region" "main" {
}

module "ha_vault" {
  source                        = "../../vault"
  ami                           = coalesce(var.custom_ami, data.aws_ami.ubuntu.id)
  project                       = var.project
  vault1_subnet                 = module.vpc.private_app_subnets[0]
  vault2_subnet                 = module.vpc.private_app_subnets[1]
  vpc_id                        = module.vpc.vpc_id
  lb_subnets                    = module.vpc.public_lb_subnets
  acm_arn                       = var.vault_acm_arn
  dns_root                      = var.vault_dns_root
  instance_type                 = var.instance_type
  vault_nproc                   = 1
  key_name                      = var.key_name
  lb_internal                   = var.lb_internal
  vault_version                 = var.vault_version
  environment                   = "test"
  acme_server                   = var.acme_server
  le_email                      = var.le_email
  enable_dynamodb_replica_table = true
  enable_ui                     = true

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}
