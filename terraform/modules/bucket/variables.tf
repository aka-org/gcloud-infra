# GCS Backend
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = ""
}
variable "gcp_region" {
  description = "The GCP region to deploy resources in"
  type        = string
  default     = "us-east1"
}
variable "bucket" {
  description = "Object defining bucket to be created"
  type = object({
    name               = string
    force_destroy      = bool
    versioning_enabled = bool
  })
}
variable "create_gcs_backend" {
  description = "Specify whether a google cloud storage backend will be created"
  type        = bool
  default     = false
}
