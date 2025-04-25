resource "random_id" "project" {
  byte_length = 8
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = "${var.project_name}-${random_id.project.hex}"
  billing_account = var.billing_account_id
  deletion_policy = var.project_deletion_policy
}

output "project_id" {
  value = google_project.project.project_id
}
