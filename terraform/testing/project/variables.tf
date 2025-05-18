# General project settings
variable "env" {
  description = "Infrastructure environment"
  type        = string
  default     = ""
}

variable "release" {
  description = "SemVer compliant version used to identify different releases of infra"
  type        = string
}

variable "gcp_region" {
  description = "The GCP region to deploy resources in"
  type        = string
  default     = "us-east1"
}
variable "project_prefix" {
  description = "A human-readable prefix for the project"
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

# Terraform state GCS Backend
variable "gcs_backend" {
  description = "If true creates bucket to store tf state and a local backend.tf"
  type        = bool
  default     = false
}
variable "buckets" {
  description = "Object describing a bucket for tf state"
  type = list(object({
    suffix             = string
    location           = string
    force_destroy      = bool
    versioning_enabled = bool
  }))
}

# Service Account
variable "service_accounts" {
  description = "List of service accounts to be created"
  type = list(object({
    id          = string
    roles       = list(string)
    create_key  = bool
    write_key   = bool
    description = string
  }))
}
