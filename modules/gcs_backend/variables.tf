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
