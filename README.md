# Xzion System - Production Azure Terraform Foundation

This repository provides a reusable, production-oriented Azure infrastructure foundation.

## Architecture

Resource Group
  -> VNet
     -> Subnets
        -> NSGs
        -> Route Tables (optional)
  -> Public IPs
  -> NICs
  -> Linux VMs

## Design principles

- Separate reusable modules
- `for_each` for scalable resources
- Explicit `depends_on` where dependency is intentional
- Input validation
- Secure-by-default VM configuration
- Managed identity support
- Azure AD SSH login support
- Optional Public IPs
- Optional accelerated networking
- No secrets committed to Git
- Environment-specific tfvars
- Remote backend configuration supplied at deployment time

## Important

Do not put passwords, SSH private keys, client secrets, or `.tfstate` files in Git.

For production, use an Azure Storage backend and Azure DevOps workload identity federation/service connection.

## Directory

```text
xzion-azure-terraform/
├── bootstrap/
├── environments/
│   └── dev/
├── modules/
│   ├── resource_group/
│   ├── network/
│   ├── subnet/
│   ├── nsg/
│   ├── public_ip/
│   ├── nic/
│   └── linux_vm/
└── .gitignore
```

## Deployment

```powershell
terraform fmt -recursive
terraform init
terraform validate
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

For production, pass backend configuration from your pipeline rather than hard-coding storage-account details in source control.
