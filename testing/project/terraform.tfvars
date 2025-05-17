project_name = "aka-org-testing"
project_labels = {
  env = "testing"
}
enable_apis = [
  "compute.googleapis.com",
  "storage.googleapis.com",
  "secretmanager.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "cloudbilling.googleapis.com",
  "serviceusage.googleapis.com",
  "iam.googleapis.com"
]
bucket = {
  location           = "us-east1"
  force_destroy      = true
  versioning_enabled = true
  labels = {
    env = "testing"
  }
}
service_accounts = [
  {
    id          = "gha-sa"
    description = "Service account used by Github Actions"
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
  }
]
