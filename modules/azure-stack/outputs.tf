output "resource_group_name" {
  description = "Name of the created resource group."
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "Virtual network ID."
  value       = azurerm_virtual_network.this.id
}

output "aks_cluster_id" {
  description = "AKS cluster ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "aks_cluster_name" {
  description = "AKS cluster name."
  value       = azurerm_kubernetes_cluster.this.name
}

output "aks_kubelet_identity_object_id" {
  description = "AKS kubelet identity object ID."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "postgres_server_id" {
  description = "Azure PostgreSQL Flexible Server ID."
  value       = azurerm_postgresql_flexible_server.this.id
}

output "postgres_fqdn" {
  description = "Private PostgreSQL server FQDN."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "postgres_database_name" {
  description = "Created PostgreSQL database name."
  value       = azurerm_postgresql_flexible_server_database.app.name
}
