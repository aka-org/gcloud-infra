variable "project_name" {
  description = "A human-readable name for the project"
  type        = string
}

variable "project_labels" {
  description = "Labels to add to project"
  type        = map(string)
}

variable "billing_account_id" {
  description = "Billing account ID to associate with the project"
  type        = string
  sensitive   = true
}

variable "bucket_name_prefix" {
  description = "The prefix of the name of the bucket that will store the tf states"
  type        = string
  default     = "tf-states"
}

variable "bucket_labels" {
  description = "Labels to add to the created bucket"
  type        = map(string)
}

variable "gcs_backend" {
  description = "If true creates bucket named after project id to store tf states and a local backend.tf"
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

variable "vpc_create" {
  description = "Set to true to create a default project vpc"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name of the project vpc"
  type        = string
  default     = "main"
}
