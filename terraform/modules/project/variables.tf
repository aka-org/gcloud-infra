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

# Google APIs
variable "enable_apis" {
  description = "Lists of Google APIs to be enabled"
  type        = list(string)
  default     = []
}

# Bucket 
variable "gcs_backend" {
  description = "If true creates bucket to store tf state and a local backend.tf"
  type        = bool
  default     = false
}
variable "tf_state_bucket" {
  description = "Object describing a bucket for tf state"
  type = object({
    location    = string 
    force_destroy      = bool
    versioning_enabled = bool
  })
}
