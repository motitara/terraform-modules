locals {
  pods_range_name     = "${var.name_prefix}-pods"
  services_range_name = "${var.name_prefix}-services"
  required_apis = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com"
  ])
}

resource "google_project_service" "required" {
  for_each = var.enable_required_apis ? local.required_apis : toset([])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = "${var.name_prefix}-vpc"
  auto_create_subnetworks = false

  depends_on = [google_project_service.required]
}

resource "google_compute_subnetwork" "gke" {
  project                  = var.project_id
  name                     = "${var.name_prefix}-gke-subnet"
  region                   = var.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = var.network_cidr
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = local.pods_range_name
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = local.services_range_name
    ip_cidr_range = var.services_cidr
  }
}

resource "google_compute_global_address" "private_services" {
  project       = var.project_id
  name          = "${var.name_prefix}-private-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.private_service_access_cidr_prefix_length
  network       = google_compute_network.this.id
}

resource "google_service_networking_connection" "private_services" {
  network                 = google_compute_network.this.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_services.name]
}

resource "google_compute_firewall" "allow_internal" {
  project = var.project_id
  name    = "${var.name_prefix}-allow-internal"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.network_cidr, var.pods_cidr, var.services_cidr]
}

resource "google_compute_router" "nat" {
  count = var.create_cloud_nat ? 1 : 0

  project = var.project_id
  name    = "${var.name_prefix}-router"
  region  = var.region
  network = google_compute_network.this.id
}

resource "google_compute_router_nat" "nat" {
  count = var.create_cloud_nat ? 1 : 0

  project                            = var.project_id
  name                               = "${var.name_prefix}-nat"
  router                             = google_compute_router.nat[0].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.gke.id
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
    secondary_ip_range_names = [
      local.pods_range_name,
      local.services_range_name
    ]
  }
}

resource "google_container_cluster" "this" {
  project                  = var.project_id
  name                     = "${var.name_prefix}-gke"
  location                 = var.region
  min_master_version       = var.kubernetes_version
  network                  = google_compute_network.this.id
  subnetwork               = google_compute_subnetwork.gke.id
  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = local.pods_range_name
    services_secondary_range_name = local.services_range_name
  }

  private_cluster_config {
    enable_private_nodes    = var.private_cluster_enabled
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []

    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks

        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  resource_labels = var.labels

  depends_on = [google_project_service.required]
}

resource "google_container_node_pool" "primary" {
  project        = var.project_id
  name           = "${var.name_prefix}-primary"
  location       = var.region
  cluster        = google_container_cluster.this.name
  node_count     = var.enable_node_autoscaling ? null : var.node_count
  node_locations = length(var.zones) > 0 ? var.zones : null

  dynamic "autoscaling" {
    for_each = var.enable_node_autoscaling ? [1] : []

    content {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
  }

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size_gb
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    labels       = var.labels

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }
}

resource "google_sql_database_instance" "this" {
  project          = var.project_id
  name             = "${var.name_prefix}-postgres"
  region           = var.region
  database_version = var.database_version

  settings {
    tier              = var.database_tier
    availability_type = "ZONAL"
    user_labels       = var.labels

    ip_configuration {
      ipv4_enabled    = var.sql_public_ipv4_enabled
      private_network = google_compute_network.this.id
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }
  }

  deletion_protection = var.deletion_protection

  depends_on = [google_service_networking_connection.private_services]
}

resource "google_sql_database" "app" {
  project  = var.project_id
  name     = var.database_name
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "app" {
  project  = var.project_id
  name     = var.database_user
  instance = google_sql_database_instance.this.name
  password = var.database_password
}
