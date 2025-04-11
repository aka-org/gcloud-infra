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

resource "google_compute_project_metadata" "default" {
  project = google_project.project.project_id 

  metadata = {
    ssh-keys = join("\n", var.admin_ssh_keys)
  }

  depends_on = [google_project_service.compute_api]
}
