resource "azurerm_public_ip" "this" {
  for_each = var.public_ips

  name                = "pip-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  zones               = each.value.zones
  tags                = var.tags
}
