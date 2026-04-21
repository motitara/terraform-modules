variable "name_prefix" {
  description = "Prefix used for all Azure resource names."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created."
  type        = string
  default     = "centralindia"
}

variable "subscription_id" {
  description = "Azure subscription ID. Leave null to use ARM_SUBSCRIPTION_ID or your active Azure CLI context."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the resource group to create."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to all supported resources."
  type        = map(string)
  default = {
    managed-by = "terraform"
  }
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
  default     = ["10.40.0.0/16"]
}

variable "aks_subnet_cidr" {
  description = "CIDR block for AKS nodes."
  type        = string
  default     = "10.40.1.0/24"
}

variable "postgres_subnet_cidr" {
  description = "CIDR block delegated to PostgreSQL."
  type        = string
  default     = "10.40.2.0/24"
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version. Leave null to use Azure's default."
  type        = string
  default     = null
}

variable "private_cluster_enabled" {
  description = "Whether to create AKS as a private cluster."
  type        = bool
  default     = false
}

variable "api_server_authorized_ip_ranges" {
  description = "CIDR ranges allowed to access the AKS API server."
  type        = list(string)
  default     = []
}

variable "node_count" {
  description = "Initial AKS system node count."
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "Azure VM size for AKS nodes."
  type        = string
  default     = "Standard_DC2ads_v5"
}

variable "enable_auto_scaling" {
  description = "Enable autoscaling for the AKS default node pool."
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "Minimum AKS node count when autoscaling is enabled."
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum AKS node count when autoscaling is enabled."
  type        = number
  default     = 3
}

variable "postgres_version" {
  description = "PostgreSQL major version for Azure Flexible Server."
  type        = string
  default     = "16"
}

variable "postgres_admin_username" {
  description = "Administrator username for PostgreSQL."
  type        = string
  default     = "pgadmin"
}

variable "postgres_admin_password" {
  description = "Administrator password for PostgreSQL."
  type        = string
  sensitive   = true
}

variable "postgres_database_name" {
  description = "Application database name."
  type        = string
  default     = "appdb"
}

variable "postgres_sku_name" {
  description = "Azure PostgreSQL Flexible Server SKU name."
  type        = string
  default     = "B_Standard_B2s"
}

variable "postgres_storage_mb" {
  description = "PostgreSQL storage size in MB."
  type        = number
  default     = 32768
}

variable "postgres_backup_retention_days" {
  description = "PostgreSQL backup retention in days."
  type        = number
  default     = 7
}
