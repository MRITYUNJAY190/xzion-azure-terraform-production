resource "azurerm_network_interface" "this" {
  for_each = var.vms

  name                = "nic-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  accelerated_networking_enabled = each.value.enable_accelerated_networking

  ip_configuration {
    name                          = "ipconfig-${each.key}"
    subnet_id                     = var.subnets[each.value.subnet_key]
    private_ip_address_allocation = each.value.private_ip_address != null ? "Static" : "Dynamic"
    private_ip_address            = each.value.private_ip_address
    public_ip_address_id          = try(
      var.public_ips[each.value.public_ip_key],
      null
    )
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "this" {
  for_each = {
    for k, vm in var.vms : k => vm
    if try(vm.subnet_key, null) != null && try(var.nsgs[try(var.subnet_nsg_map[vm.subnet_key], vm.subnet_key)], null) != null
  }

  network_interface_id      = azurerm_network_interface.this[each.key].id
  network_security_group_id = var.nsgs[try(var.subnet_nsg_map[each.value.subnet_key], each.value.subnet_key)]
}
