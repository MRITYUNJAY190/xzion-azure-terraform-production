output "public_ips" {
  value = {
    for k, v in azurerm_public_ip.this : k => v.id
  }
}

output "public_ip_addresses" {
  value = {
    for k, v in azurerm_public_ip.this : k => v.ip_address
  }
}
