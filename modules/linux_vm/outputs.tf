output "vm_ids" {
  value = {
    for k, v in azurerm_linux_virtual_machine.this : k => v.id
  }
}

output "vm_principal_ids" {
  value = {
    for k, v in azurerm_linux_virtual_machine.this : k => v.identity[0].principal_id
  }
}
