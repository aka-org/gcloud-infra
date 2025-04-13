resource "google_project" "project" {
  name       = var.project_name
  project_id = var.project_id
  billing_account = var.billing_account_id
  deletion_policy = var.project_deletion_policy
}
