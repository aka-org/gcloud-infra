# GCS Backend
variable "buckets" {
  description = "List of buckets to create"
  type        = list(object({
    name = string
    location = string
    force_destroy = bool
    versioning_enabled = bool
  }))
}
variable "create_gcs_backend" {
  description = "Specify whether a google cloud storage backend will be created"
  type        = bool
  default     = false
}
