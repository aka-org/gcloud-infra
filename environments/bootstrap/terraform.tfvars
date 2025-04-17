gcp_region   = "us-east1"
gcp_zone     = "us-east1-b"
project_name = "gcloud-infra"
enable_apis = [
  "compute.googleapis.com",
  "storage.googleapis.com",
  "oslogin.googleapis.com"
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
service_accounts = [
  {
    id           = "ansible-sa"
    display_name = "ansible-sa"
    roles = [
      "roles/compute.osAdminLogin"
    ]
    pub_key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJI1QdTQkaL/+CRzCTUlrKHLAQWRxjVdR5Y1C0FA3o2a 06042025"
    create_key = false
  },
  {
    id           = "terraform-sa"
    display_name = "terraform-sa"
    roles = [
      "roles/compute.admin",
      "roles/compute.networkAdmin",
      "roles/storage.objectAdmin"
    ]
    pub_key    = ""
    create_key = true
  }
]
