variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "public_ips" {
  type = map(object({
    allocation_method = optional(string, "Static")
    sku               = optional(string, "Standard")
    zones             = optional(list(string), ["1", "2", "3"])
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
