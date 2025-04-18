# General project settings
variable "gcp_region" {
  description = "The GCP region to deploy resources in"
  type        = string
  default     = "us-east1"
}
variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
  default     = "us-east1-b"
}
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  sensitive   = true
  default     = ""
}
variable "project_name" {
  description = "A human-readable name for the project"
  type        = string
  default     = ""
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
  default     = ""
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
  default = []
}
variable "create_gcs_backend" {
  description = "Specify whether a google cloud storage backend will be created"
  type        = bool
  default     = false
}

# Service Accounts
variable "service_accounts" {
  description = "List of service accounts to be created"
  type = list(object({
    id           = string
    display_name = string
    roles        = list(string)
    create_key   = bool
  }))
  default = []
}

