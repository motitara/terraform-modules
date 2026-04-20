# Azure Stack Module

Creates an Azure application foundation:

- Resource group and virtual network.
- AKS cluster with Azure CNI networking and RBAC enabled.
- Private Azure Database for PostgreSQL Flexible Server.
- Dedicated AKS and PostgreSQL subnets, NSGs, subnet delegation, and private DNS.

## Required Inputs

- `name_prefix`
- `location`
- `postgres_admin_password`

See `variables.tf` for optional sizing, networking, and security controls.
