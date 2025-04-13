# General project settings
variable "gcp_region" {
  description = "The GCP region to deploy resources in"
  type        = string
}
variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
}
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  sensitive   = true
}
variable "project_name" {
  description = "A human-readable name for the project"
  type        = string
}
variable "project_deletion_policy" {
  description = "Project deletion policy (e.g. PREVENT or DELETE)"
  type        = string
  default     = "PREVENT"
}
variable "billing_account_id" {
  description = "Billing account ID to associate with the project"
  type        = string
  sensitive   = true
}

# Google APIs
variable "enable_apis" {
  description = "Lists of Google APIs to be enabled"
  type        = list(string)
  default     = []
}

# GCS Backend
variable "buckets" {
  description = "List of buckets to create"
  type = list(object({
    name               = string
    location           = string
    force_destroy      = bool
    versioning_enabled = bool
  }))
}
variable "create_gcs_backend" {
  description = "Specify whether a google cloud storage backend will be created"
  type        = bool
  default     = false
}
