variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "At least one VNet CIDR is required."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
