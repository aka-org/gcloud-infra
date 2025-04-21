resource "google_storage_bucket" "bucket" {
  for_each = { for bucket in var.buckets : bucket.name => bucket }
  name          = each.value.name
  location      = each.value.location
  force_destroy = each.value.force_destroy
  versioning {
    enabled = each.value.versioning_enabled
  }
}


resource "local_file" "default" {
  count = var.create_gcs_backend ? 1 : 0
  file_permission = "0644"
  filename        = "${path.cwd}/backend.tf"

  content = <<-EOT
  terraform {
    backend "gcs" {
    }
  }
  EOT
}
