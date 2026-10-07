output "resource_group_name" {
  value = module.resource_group.name
}

output "vnet_id" {
  value = module.network.id
}

output "subnet_ids" {
  value = module.subnet.subnets
}

output "public_ip_addresses" {
  value = module.public_ip.public_ip_addresses
}

output "vm_ids" {
  value = module.linux_vm.vm_ids
}

output "vm_private_ips" {
  value = module.nic.private_ips
}
