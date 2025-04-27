locals {
  # Generic
  project_name = "${var.project_prefix}-${var.env}"
  project_id   = "${local.project_name}-${random_id.project.hex}"
  # Bucket
  bucket_name  = lower("${local.project_id}-tfstate")
}

resource "random_id" "project" {
  byte_length = 4
}

resource "google_project" "project" {
  name            = local.project_name
  project_id      = local.project_id
  billing_account = var.billing_account_id
  deletion_policy = var.project_deletion_policy
}

resource "google_billing_project_info" "default" {
  project         = google_project.project.project_id
  billing_account = var.billing_account_id
}

resource "google_project_service" "enabled_api" {
  for_each = toset(var.enable_apis)
  project  = google_project.project.project_id 
  service  = each.value
}

resource "google_storage_bucket" "bucket" {
  for_each = var.gcs_backend ? { "tf-state-bucket" = {} } : {}
  name          = local.bucket_name 
  location      = var.tf_state_bucket.location
  project       = google_project.project.project_id
  force_destroy = var.tf_state_bucket.force_destroy
  versioning {
    enabled = var.tf_state_bucket.versioning_enabled
  }
}

resource "local_file" "gcs_backend" {
  for_each = var.gcs_backend ? { tf-state-backend = {} } : {}

  file_permission = "0644"
  filename        = "${path.cwd}/backend.tf"

  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.bucket["tf-state-bucket"].name}" 
    }
  }
  EOT
}
