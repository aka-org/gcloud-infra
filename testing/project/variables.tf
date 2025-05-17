variable "project_name" {
  description = "A human-readable name for the project"
  type        = string
}

variable "project_labels" {
  description = "Labels to add to project"
  type        = map(string)
  default     = {}
}

variable "billing_account_id" {
  description = "Billing account ID to associate with the project"
  type        = string
  sensitive   = true
}

variable "enable_apis" {
  description = "Lists of Google APIs to be enabled"
  type        = list(string)
  default     = []
}

variable "gcs_backend" {
  description = "If true creates bucket named after project id to store tf states and a local backend.tf"
  type        = bool
  default     = true
}

variable "bucket" {
  description = "Object describing a bucket for project tf states"
  type = object({
    location           = string
    force_destroy      = bool
    versioning_enabled = bool
    labels             = map(string)
  })
}

variable "service_accounts" {
  description = "List of service accounts with role bindings"
  type = list(object({
    id          = string
    roles       = list(string)
    description = string
  }))
}

variable "gha_wif_enabled" {
  description = "Set to true to setup Workload Identity Federation for Github Actions"
  type        = bool
  default     = true
}

variable "project_deletion_policy" {
  description = " Project deletion policy (e.g. PREVENT or DELETE)"
  type        = string
  default     = "PREVENT"
}

variable "gha_wif_sa" {
  description = "Service account to be associated with Github identity pool, must be defined in service accounts"
  type        = string
  default     = "gha-sa"
}

variable "gha_wif_org" {
  description = "Github org or user from which actions are allowed to authenticate via WIF"
  type        = string
  default     = "aka-org"
}

variable "gha_wif_repo" {
  description = "Github repo from which actions are allowed to authenticate via WIF"
  type        = string
  default     = ""
}

variable "create_vpc" {
  description = "Set to true to create a default project vpc"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name of the project vpc"
  type        = string
  default     = "main"
}
