variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnets" {
  type = map(string)
}

variable "nsgs" {
  type = map(string)
}

variable "subnet_nsg_map" {
  type    = map(string)
  default = {}
}

variable "public_ips" {
  type    = map(string)
  default = {}
}

variable "vms" {
  type = map(object({
    subnet_key                       = string
    vm_size                          = string
    admin_username                   = string
    ssh_public_key                   = string
    create_public_ip                 = optional(bool, false)
    public_ip_key                    = optional(string)
    private_ip_address               = optional(string)
    enable_accelerated_networking    = optional(bool, false)
    os_disk_size_gb                  = optional(number, 64)
    tags                             = optional(map(string), {})
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
