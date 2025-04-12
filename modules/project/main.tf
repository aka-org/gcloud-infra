resource "google_project" "project" {
  name       = var.project_name
  project_id = var.project_id
  billing_account = var.billing_account_id
  deletion_policy = var.project_deletion_policy
}

resource "google_project_service" "compute_api" {
  project = google_project.project.project_id
  service = "compute.googleapis.com"
}
