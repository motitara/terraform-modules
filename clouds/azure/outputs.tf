output "resource_group_name" {
  description = "Name of the created resource group."
  value       = module.stack.resource_group_name
}

output "aks_cluster_name" {
  description = "AKS cluster name."
  value       = module.stack.aks_cluster_name
}

output "postgres_fqdn" {
  description = "Private PostgreSQL FQDN."
  value       = module.stack.postgres_fqdn
}

output "postgres_database_name" {
  description = "Created PostgreSQL database name."
  value       = module.stack.postgres_database_name
}
