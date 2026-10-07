locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = var.common_tags
}

module "network" {
  source = "../../modules/network"

  name                = "vnet-${local.name_prefix}"
  location            = var.location
  resource_group_name = module.resource_group.name
  address_space       = var.vnet_address_space
  tags                = var.common_tags

  depends_on = [
    module.resource_group
  ]
}

module "subnet" {
  source = "../../modules/subnet"

  vnet_name           = module.network.name
  resource_group_name = module.resource_group.name
  location            = var.location
  subnets             = var.subnets
  tags                = var.common_tags

  depends_on = [
    module.network
  ]
}

module "nsg" {
  source = "../../modules/nsg"

  resource_group_name = module.resource_group.name
  location            = var.location
  nsg_rules           = var.nsg_rules
  tags                = var.common_tags

  depends_on = [
    module.resource_group
  ]
}

module "public_ip" {
  source = "../../modules/public_ip"

  resource_group_name = module.resource_group.name
  location            = var.location
  public_ips          = var.public_ips
  tags                = var.common_tags

  depends_on = [
    module.resource_group
  ]
}

module "nic" {
  source = "../../modules/nic"

  resource_group_name = module.resource_group.name
  location            = var.location
  vnet_name           = module.network.name
  subnets             = module.subnet.subnets
  nsgs                = module.nsg.nsgs
  public_ips          = module.public_ip.public_ips
  vms                 = var.vms
  tags                = var.common_tags

  depends_on = [
    module.subnet,
    module.nsg,
    module.public_ip
  ]
}

module "linux_vm" {
  source = "../../modules/linux_vm"

  resource_group_name = module.resource_group.name
  location            = var.location
  vms                 = var.vms
  nic_ids             = module.nic.nic_ids
  tags                = var.common_tags

  depends_on = [
    module.nic
  ]
}
