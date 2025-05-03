# General project settings
variable "infra_version" {
  description = "Version of the overall infrastructure"
  type        = string
  default     = "v20250503"
}
variable "env" {
  description = "Infrastructure environment"
  type        = string
  default     = ""
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
variable "tf_state_bucket" {
  description = "Object describing a terraform state bucket to be created"
  type = object({
    force_destroy      = bool
    versioning_enabled = bool
    location           = string
  })
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

# Network
variable "vpc_name" {
  description = "Name of the vpc to be created"
  type        = string
  default     = ""
}

# Subnets
variable "subnetworks" {
  description = "List of subnets to create"
  type = list(object({
    name          = string
    ip_cidr_range = string
  }))
  default = []
}

# Generic Firewall Rules
variable "firewall_rules" {
  description = "List of firewall rules to create"
  type = list(object({
    name          = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
    tags          = list(string)
  }))
  default = []
}

# Secrets
# Secrets
variable "secrets" {
  description = "List of Secret objects to be created"
  type = list(object({
    id          = string
    add_version = bool
  }))
}
variable "secret_values" {
  description = "Map of secret key-value pairs"
  type        = map(string)
  sensitive   = true
  default     = {}
}
