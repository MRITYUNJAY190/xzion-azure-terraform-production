variable "vnet_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
    nsg_name         = optional(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
