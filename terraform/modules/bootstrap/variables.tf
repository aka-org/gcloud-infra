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
variable "tf_state_bucket" {
  description = "Object describing a terraform state bucket to be created"
  type = object({
    name               = string
    force_destroy      = bool
    versioning_enabled = bool
  })
}
variable "create_gcs_backend" {
  description = "Specify whether a backend.tf with gcs backend will be created locally"
  type        = bool
  default     = false
}

# Service Accounts
variable "tf_service_account" {
  description = "Terraform service account to be created"
  type = object({
    id           = string
    display_name = string
    roles        = list(string)
    create_key   = bool
  })
}

# Network
variable "network_name" {
  description = "vpc network name"
  type        = string
}

# Subnets
variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name          = string
    ip_cidr_range = string
    roles         = list(string)
  }))
}

# Firewall rules
variable "firewall_rules" {
  description = "List of firewall rules to create"
  type = list(object({
    name          = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
    tags          = list(string)
  }))
}
