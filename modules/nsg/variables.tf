variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "nsg_rules" {
  type = map(map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = optional(string, "*")
    destination_port_range     = optional(string, "*")
    source_address_prefix      = optional(string, "*")
    destination_address_prefix = optional(string, "*")
    description                = optional(string)
  })))
}

variable "tags" {
  type    = map(string)
  default = {}
}
