resource "google_storage_bucket" "bucket" {
  name          = var.bucket.name
  location      = var.gcp_region
  project       = var.project_id
  force_destroy = var.bucket.force_destroy
  versioning {
    enabled = var.bucket.versioning_enabled
  }
}

resource "local_file" "default" {
  count           = var.create_gcs_backend ? 1 : 0
  file_permission = "0644"
  filename        = "${path.cwd}/backend.tf"

  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.bucket.name}"
    }
  }
  EOT
}
