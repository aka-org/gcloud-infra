variable "project_name" {
  description = "A human-readable name for the project"
  type        = string
}

variable "env" {
  description = "Provisioned environment name (e.g., testing, prod)"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account ID to associate with the project"
  type        = string
  sensitive   = true
}

variable "enable_apis" {
  description = "Lists of additional Google APIs to be enabled"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

variable "sa_roles" {
  description = "List of roles to be assigned to the default service account"
  type        = list(string)
  default = [
    "roles/compute.admin",
    "roles/compute.networkAdmin",
    "roles/secretmanager.admin"
  ]
}

variable "bucket_name_prefix" {
  description = "The prefix of the name of the bucket that will store the tf states"
  type        = string
  default     = "tf-states"
}

variable "gcs_backend" {
  description = "If true, creates backend config for GCS state"
  type        = bool
  default     = true
}

variable "gha_wif_enabled" {
  description = "Set to true to setup Workload Identity Federation for Github Actions"
  type        = bool
  default     = true
}

variable "gha_owner_id" {
  description = "ID of the owner of the github repos allowed to authenticate via identity provider"
  type        = string
  default     = "208289232"
}

variable "gha_allowed_repos" {
  description = "List of repos allowed to authenticate via identity provider"
  type        = list(string)
  default = [
    "aka-org/gcloud-infra",
    "aka-org/gcloud-os-images"
  ]
}
