# terraform-modules

Reusable Terraform modules for provisioning a Kubernetes application stack on Azure or Google Cloud.

The repository contains cloud-specific stack modules with a similar input shape:

- Kubernetes: AKS on Azure, GKE on Google Cloud.
- PostgreSQL: Azure Database for PostgreSQL Flexible Server, Google Cloud SQL for PostgreSQL.
- Networking and security: private network, Kubernetes subnet/ranges, database private connectivity, and basic firewall/security rules.

## Layout

```text
modules/
  azure-stack/     # AKS + Azure PostgreSQL Flexible Server + VNet
  gcp-stack/       # GKE + Cloud SQL PostgreSQL + VPC
clouds/
  azure/           # Minimal Azure stack wiring
  gcp/             # Minimal GCP stack wiring
```

## Usage

Pick the cloud example you want to deploy, create a `terraform.tfvars` file, then run Terraform from that example directory.

```powershell
cd clouds/azure
terraform init `
  -backend-config="resource_group_name=<state-resource-group>" `
  -backend-config="storage_account_name=<state-storage-account>" `
  -backend-config="container_name=<state-container>" `
  -backend-config="key=dev/idea-board-dev.tfstate"
terraform plan
terraform apply
```

or:

```powershell
cd clouds/gcp
terraform init `
  -backend-config="bucket=<state-bucket>" `
  -backend-config="prefix=dev/idea-board-dev"
terraform plan
terraform apply
```

For a quick local module syntax check without remote state, run `terraform init -backend=false` from a cloud directory.

## Azure Example Variables

```hcl
subscription_id         = "00000000-0000-0000-0000-000000000000"
name_prefix             = "idea-board-dev"
location                = "centralindia"
postgres_admin_password = "replace-with-a-strong-password"
```

Authenticate with Azure before applying:

```powershell
az login
az account set --subscription "<subscription-id>"
```

## GCP Example Variables

```hcl
project_id        = "my-gcp-project"
name_prefix       = "idea-board-dev"
region            = "us-central1"
database_password = "replace-with-a-strong-password"
```

Authenticate with Google Cloud before applying:

```powershell
gcloud auth application-default login
gcloud config set project "<project-id>"
```

## GitHub Actions Deployment

The repository includes a manual GitHub Actions workflow at `.github/workflows/terraform-deploy.yml`.

Open **Actions > Terraform Deploy > Run workflow**, then choose:

- `cloud`: `azure` or `gcp`
- `terraform_action`: `plan`, `apply`, or `destroy`
- `target_environment`: GitHub environment to use for approvals and scoped secrets
- `name_prefix`: stack name prefix, for example `idea-board-dev`
- `azure_location` or `gcp_region`
- `gcp_project_id` when deploying GCP
- `confirm_destroy`: type `destroy` only when running a destroy

The workflow uses OIDC federation for cloud authentication and remote Terraform state. Create the remote state storage before the first run.

For Azure on GitHub-hosted runners, keep the workflow login set to `auth-type: SERVICE_PRINCIPAL`. `auth-type: IDENTITY` is only for managed identity login from Azure-hosted self-hosted runners.

### GitHub Secrets

Set these as repository secrets or environment-scoped secrets.

For Azure:

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_POSTGRES_ADMIN_PASSWORD`

For GCP:

- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT`
- `GCP_DATABASE_PASSWORD`

### GitHub Variables

Set these as repository variables or environment-scoped variables.

For Azure remote state:

- `AZURE_TF_STATE_RESOURCE_GROUP`
- `AZURE_TF_STATE_STORAGE_ACCOUNT`
- `AZURE_TF_STATE_CONTAINER`

For GCP remote state:

- `GCP_TF_STATE_BUCKET`

### Cloud Identity Permissions

The Azure federated identity should be able to:

- Manage the target subscription or resource group.
- Read and write the Azure Storage container used for Terraform state.

Create one federated identity credential on the Azure app registration for each GitHub environment used by the workflow. For example, when `target_environment` is `dev`, GitHub sends this OIDC subject:

```text
repo:motitara/terraform-modules:environment:dev
```

Azure CLI example:

```powershell
$appId = "<AZURE_CLIENT_ID>"

$credentialPath = "$env:TEMP\github-dev-federated-credential.json"

@{
  name        = "github-dev"
  issuer      = "https://token.actions.githubusercontent.com"
  subject     = "repo:motitara/terraform-modules:environment:dev"
  audiences   = @("api://AzureADTokenExchange")
  description = "GitHub Actions OIDC for terraform-modules dev environment"
} | ConvertTo-Json -Depth 10 | Set-Content -Path $credentialPath -Encoding utf8

az ad app federated-credential create `
  --id $appId `
  --parameters "@$credentialPath"
```

For another GitHub environment, create another credential with the matching subject, such as `repo:motitara/terraform-modules:environment:prod`.

The GCP service account should be able to:

- Manage Compute, GKE, Service Networking, and Cloud SQL resources in the target project.
- Read and write objects in the GCS bucket used for Terraform state.
- Enable project services if `enable_required_apis` remains `true`.

## Notes

- Defaults are intentionally small for development. Increase node counts, database sizes, availability settings, and authorized networks for production.
- Database resources are configured for private networking by default.
- Kubernetes API endpoints are public by default in the cloud wrappers, with optional authorized CIDR controls. You can enable private clusters through module variables.
- GCP creates Cloud NAT by default so private GKE nodes can reach external registries and package repositories.
