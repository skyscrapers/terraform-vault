module "vpc" {
  source                            = "github.com/skyscrapers/terraform-network//vpc?ref=3.4.1"
  cidr_block                        = "${var.cidr_block}"
  environment                       = "${terraform.workspace}"
  project                           = "${var.project}"
  amount_private_management_subnets = 2
}
