locals {
  env     = var.env
  region  = var.location
  prefix  = "myorg"

  name_rg   = "${local.prefix}-${local.env}-${local.region}-rg"
  name_vnet = "${local.prefix}-${local.env}-${local.region}-vnet"
  name_nsg  = "${local.prefix}-${local.env}-${local.region}-nsg"
  name_vm   = "${local.prefix}-${local.env}-${local.region}-vm"

  tags = {
    environment = local.env
    region      = local.region
    created_by  = "terraform"
  }
}
