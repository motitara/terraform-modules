output "network_id" {
  description = "VPC network ID."
  value       = module.stack.network_id
}

output "gke_cluster_name" {
  description = "GKE cluster name."
  value       = module.stack.gke_cluster_name
}

output "postgres_instance_connection_name" {
  description = "Cloud SQL instance connection name."
  value       = module.stack.postgres_instance_connection_name
}

output "postgres_private_ip_address" {
  description = "Cloud SQL private IP address."
  value       = module.stack.postgres_private_ip_address
}

output "postgres_database_name" {
  description = "Created PostgreSQL database name."
  value       = module.stack.postgres_database_name
}
