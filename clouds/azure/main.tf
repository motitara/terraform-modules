module "stack" {
  source = "../../modules/azure-stack"

  name_prefix             = var.name_prefix
  location                = var.location
  postgres_admin_password = var.postgres_admin_password

  resource_group_name             = var.resource_group_name
  tags                            = var.tags
  vnet_address_space              = var.vnet_address_space
  aks_subnet_cidr                 = var.aks_subnet_cidr
  postgres_subnet_cidr            = var.postgres_subnet_cidr
  kubernetes_version              = var.kubernetes_version
  private_cluster_enabled         = var.private_cluster_enabled
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  node_count                      = var.node_count
  node_vm_size                    = var.node_vm_size
  enable_auto_scaling             = var.enable_auto_scaling
  min_node_count                  = var.min_node_count
  max_node_count                  = var.max_node_count
  postgres_version                = var.postgres_version
  postgres_admin_username         = var.postgres_admin_username
  postgres_database_name          = var.postgres_database_name
  postgres_sku_name               = var.postgres_sku_name
  postgres_storage_mb             = var.postgres_storage_mb
  postgres_backup_retention_days  = var.postgres_backup_retention_days
}
