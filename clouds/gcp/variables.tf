variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for all GCP resource names."
  type        = string
}

variable "region" {
  description = "GCP region where regional resources will be created."
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "Zones used by the GKE node pool."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels applied to supported GCP resources."
  type        = map(string)
  default = {
    managed-by = "terraform"
  }
}

variable "enable_required_apis" {
  description = "Whether to enable the GCP APIs required by this stack."
  type        = bool
  default     = true
}

variable "network_cidr" {
  description = "Primary subnet CIDR for GKE nodes."
  type        = string
  default     = "10.50.0.0/20"
}

variable "pods_cidr" {
  description = "Secondary CIDR range for GKE pods."
  type        = string
  default     = "10.52.0.0/16"
}

variable "services_cidr" {
  description = "Secondary CIDR range for GKE services."
  type        = string
  default     = "10.53.0.0/20"
}

variable "private_service_access_cidr_prefix_length" {
  description = "Prefix length for the private service access reserved range."
  type        = number
  default     = 16
}

variable "create_cloud_nat" {
  description = "Whether to create Cloud NAT for private GKE nodes."
  type        = bool
  default     = true
}

variable "kubernetes_version" {
  description = "GKE Kubernetes version. Leave null to use Google's default."
  type        = string
  default     = null
}

variable "private_cluster_enabled" {
  description = "Whether to create GKE nodes with private IPs."
  type        = bool
  default     = true
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the private GKE control plane."
  type        = string
  default     = "172.16.0.0/28"
}

variable "master_authorized_networks" {
  description = "CIDR blocks authorized to access the GKE control plane."
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "node_count" {
  description = "Initial GKE node count per zone."
  type        = number
  default     = 2
}

variable "min_node_count" {
  description = "Minimum GKE node count per zone when autoscaling is enabled."
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum GKE node count per zone when autoscaling is enabled."
  type        = number
  default     = 3
}

variable "enable_node_autoscaling" {
  description = "Enable autoscaling for the GKE default node pool."
  type        = bool
  default     = true
}

variable "node_machine_type" {
  description = "GCE machine type for GKE nodes."
  type        = string
  default     = "e2-standard-2"
}

variable "node_disk_size_gb" {
  description = "Boot disk size for GKE nodes in GB."
  type        = number
  default     = 20
}

variable "database_version" {
  description = "Cloud SQL PostgreSQL database version."
  type        = string
  default     = "POSTGRES_16"
}

variable "database_tier" {
  description = "Cloud SQL machine tier."
  type        = string
  default     = "db-f1-micro"
}

variable "database_name" {
  description = "Application database name."
  type        = string
  default     = "appdb"
}

variable "database_user" {
  description = "Application database user."
  type        = string
  default     = "appuser"
}

variable "database_password" {
  description = "Application database password."
  type        = string
  sensitive   = true
}

variable "sql_public_ipv4_enabled" {
  description = "Whether to enable public IPv4 on Cloud SQL."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection on the Cloud SQL instance."
  type        = bool
  default     = true
}
