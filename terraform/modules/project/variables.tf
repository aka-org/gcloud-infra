# General project settings
variable "env" {
  description = "Infrastructure environment"
  type        = string
  default     = ""
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

variable "release" {
  description = "SemVer compliant version used to identify different releases of infra"
  type        = string
}

# Google APIs
variable "enable_apis" {
  description = "Lists of Google APIs to be enabled"
  type        = list(string)
  default     = []
}

# Buckets 
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
