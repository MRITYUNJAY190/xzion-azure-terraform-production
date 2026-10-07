resource "azurerm_network_security_group" "this" {
  for_each = var.nsg_rules

  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = {
    for item in flatten([
      for nsg_key, rules in var.nsg_rules : [
        for rule_key, rule in rules : merge(rule, {
          nsg_key  = nsg_key
          rule_key = rule_key
        })
      ]
    ]) : "${item.nsg_key}.${item.rule_key}" => item
  }

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.this[each.value.nsg_key].name
  description                 = each.value.description
}
