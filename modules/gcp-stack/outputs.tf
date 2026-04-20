output "network_id" {
  description = "VPC network ID."
  value       = google_compute_network.this.id
}

output "subnet_id" {
  description = "GKE subnet ID."
  value       = google_compute_subnetwork.gke.id
}

output "gke_cluster_id" {
  description = "GKE cluster ID."
  value       = google_container_cluster.this.id
}

output "gke_cluster_name" {
  description = "GKE cluster name."
  value       = google_container_cluster.this.name
}

output "gke_endpoint" {
  description = "GKE control plane endpoint."
  value       = google_container_cluster.this.endpoint
  sensitive   = true
}

output "postgres_instance_connection_name" {
  description = "Cloud SQL instance connection name."
  value       = google_sql_database_instance.this.connection_name
}

output "postgres_private_ip_address" {
  description = "Cloud SQL private IP address."
  value       = google_sql_database_instance.this.private_ip_address
}

output "postgres_database_name" {
  description = "Created PostgreSQL database name."
  value       = google_sql_database.app.name
}
