# GCP Stack Module

Creates a Google Cloud application foundation:

- Custom VPC and regional subnet with secondary ranges for GKE pods and services.
- Private GKE cluster with Workload Identity.
- Cloud SQL for PostgreSQL using private service access.
- Internal firewall rules, required APIs, and Cloud NAT for private nodes.

## Required Inputs

- `project_id`
- `name_prefix`
- `region`
- `database_password`

See `variables.tf` for optional sizing, networking, and security controls.
