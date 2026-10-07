variable "location" {
  type        = string
  description = "Azure region."
  default     = "East US"
}

variable "environment" {
  type        = string
  description = "Environment name."
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "qa", "prod"], var.environment)
    error_message = "environment must be dev, test, qa, or prod."
  }
}

variable "project_name" {
  type        = string
  description = "Project/system name."
  default     = "xzion"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.20.0.0/16"]
}

variable "subnets" {
  description = "Subnet definitions."
  type = map(object({
    address_prefixes = list(string)
    nsg_name         = optional(string)
  }))

  default = {
    frontend = {
      address_prefixes = ["10.20.1.0/24"]
      nsg_name         = "frontend"
    }
    backend = {
      address_prefixes = ["10.20.2.0/24"]
      nsg_name         = "backend"
    }
    database = {
      address_prefixes = ["10.20.3.0/24"]
      nsg_name         = "database"
    }
  }
}

variable "nsg_rules" {
  description = "NSG rules per subnet/NSG."
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

  default = {
    frontend = {
      allow_https = {
        priority               = 100
        direction              = "Inbound"
        access                 = "Allow"
        protocol               = "Tcp"
        source_address_prefix  = "*"
        destination_port_range = "443"
      }
    }

    backend = {
      allow_app = {
        priority               = 100
        direction              = "Inbound"
        access                 = "Allow"
        protocol               = "Tcp"
        source_address_prefix  = "10.20.1.0/24"
        destination_port_range = "8080"
      }
    }

    database = {
      allow_postgresql = {
        priority               = 100
        direction              = "Inbound"
        access                 = "Allow"
        protocol               = "Tcp"
        source_address_prefix  = "10.20.2.0/24"
        destination_port_range = "5432"
      }
    }
  }
}

variable "public_ips" {
  description = "Public IP definitions."
  type = map(object({
    allocation_method = optional(string, "Static")
    sku               = optional(string, "Standard")
    zones             = optional(list(string), ["1", "2", "3"])
  }))
  default = {
    frontend = {}
  }
}

variable "vms" {
  description = "Linux VM definitions."
  type = map(object({
    subnet_key                    = string
    vm_size                       = string
    admin_username                = string
    ssh_public_key                = string
    create_public_ip              = optional(bool, false)
    public_ip_key                 = optional(string)
    private_ip_address            = optional(string)
    enable_accelerated_networking = optional(bool, false)
    os_disk_size_gb               = optional(number, 64)
    tags                          = optional(map(string), {})
  }))

  default = {
    frontend = {
      subnet_key       = "frontend"
      vm_size          = "Standard_D2s_v5"
      admin_username   = "azureadmin"
      ssh_public_key   = "REPLACE_WITH_SSH_PUBLIC_KEY"
      create_public_ip = true
      public_ip_key    = "frontend"
    }
  }
}

variable "common_tags" {
  type = map(string)
  default = {
    Project     = "Xzion"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
