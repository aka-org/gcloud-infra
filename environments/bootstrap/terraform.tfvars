gcp_region   = "us-east1"
gcp_zone     = "us-east1-b"
project_name = "gcloud-infra"
enable_apis = [
  "compute.googleapis.com",
  "storage.googleapis.com"
]
buckets = [
  {
    name               = "bootstrap-tfstate-13042025"
    location           = "us-east1"
    force_destroy      = false
    versioning_enabled = true
  },
  {
    name               = "test-tfstate-13042025"
    location           = "us-east1"
    force_destroy      = false
    versioning_enabled = true
  }
]
create_gcs_backend = true
sa_id              = "terraform-sa"
sa_display_name    = "terraform-sa"
sa_roles = [
  "roles/compute.admin",
  "roles/compute.networkAdmin",
  "roles/storage.objectAdmin"
]
