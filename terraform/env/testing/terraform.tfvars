infra_version           = "v20250503"
env                     = "testing"
gcp_region              = "us-east1"
project_prefix          = "gcloud-infra"
project_deletion_policy = "DELETE"
enable_apis = [
  "compute.googleapis.com",
  "storage.googleapis.com",
  "secretmanager.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "cloudbilling.googleapis.com",
  "serviceusage.googleapis.com",
  "iam.googleapis.com"
]
buckets = [
  {
    suffix             = "project-tf-state"
    location           = "us-east1"
    force_destroy      = true
    versioning_enabled = true
  },
  {
    suffix             = "network-tf-state"
    location           = "us-east1"
    force_destroy      = true
    versioning_enabled = true
  },
  {
    suffix             = "infra-tf-state"
    location           = "us-east1"
    force_destroy      = true
    versioning_enabled = true
  },
  {
    suffix             = "k8s-blue-tf-state"
    location           = "us-east1"
    force_destroy      = true
    versioning_enabled = true
  },
  {
    suffix             = "k8s-green-tf-state"
    location           = "us-east1"
    force_destroy      = true
    versioning_enabled = true
  }
]
gcs_backend = true
service_accounts = [
  {
    id          = "terraform"
    description = "Service account used by Terraform for provisioning"
    roles = [
      "roles/compute.admin",
      "roles/compute.networkAdmin",
      "roles/storage.admin",
      "roles/secretmanager.admin",
      "roles/resourcemanager.projectIamAdmin",
      "roles/iam.serviceAccountUser",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountKeyAdmin"
    ]
    create_key = true
    write_key  = true
  },
  {
    id          = "load-balancer"
    description = "Service account used by Load-balancer nodes"
    roles = [
      "roles/compute.instanceAdmin"
    ]
    create_key = false
    write_key  = false
  },
  {
    id          = "k8s-node"
    description = "Service account used by K8s nodes"
    roles = [
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.secretVersionAdder",
      "roles/compute.viewer"
    ]
    create_key = false
    write_key  = false
  }
]
