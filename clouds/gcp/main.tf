module "stack" {
  source = "../../modules/gcp-stack"

  project_id        = var.project_id
  name_prefix       = var.name_prefix
  region            = var.region
  database_password = var.database_password

  zones                                     = var.zones
  labels                                    = var.labels
  enable_required_apis                      = var.enable_required_apis
  network_cidr                              = var.network_cidr
  pods_cidr                                 = var.pods_cidr
  services_cidr                             = var.services_cidr
  private_service_access_cidr_prefix_length = var.private_service_access_cidr_prefix_length
  create_cloud_nat                          = var.create_cloud_nat
  kubernetes_version                        = var.kubernetes_version
  private_cluster_enabled                   = var.private_cluster_enabled
  master_ipv4_cidr_block                    = var.master_ipv4_cidr_block
  master_authorized_networks                = var.master_authorized_networks
  node_count                                = var.node_count
  min_node_count                            = var.min_node_count
  max_node_count                            = var.max_node_count
  enable_node_autoscaling                   = var.enable_node_autoscaling
  node_machine_type                         = var.node_machine_type
  node_disk_size_gb                         = var.node_disk_size_gb
  database_version                          = var.database_version
  database_tier                             = var.database_tier
  database_name                             = var.database_name
  database_user                             = var.database_user
  sql_public_ipv4_enabled                   = var.sql_public_ipv4_enabled
  deletion_protection                       = var.deletion_protection
}
