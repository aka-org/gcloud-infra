resource "google_storage_bucket" "bucket" {
  for_each = { for bucket in var.buckets : bucket.name => bucket }
  name          = each.value.name
  location      = each.value.location
  force_destroy = each.value.force_destroy
  versioning {
    enabled = each.value.versioning_enabled
  }
}
