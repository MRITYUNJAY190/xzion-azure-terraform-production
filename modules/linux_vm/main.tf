resource "azurerm_linux_virtual_machine" "this" {
  for_each = var.vms

  name                = "vm-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  network_interface_ids = [
    var.nic_ids[each.key]
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = each.value.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = each.value.os_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  tags = merge(var.tags, each.value.tags)
}
