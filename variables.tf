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

# Service Account
variable "sa_id" {
  description = "The ID for the service account (e.g., 'terraform-sa')"
  type        = string
  default     = ""
}
variable "sa_display_name" {
  description = "Display name for the service account"
  type        = string
  default     = ""
}
variable "sa_roles" {
  description = "List of IAM roles to bind to the service account"
  type        = list(string)
  default     = []
}

# Network
variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = ""
}

# Subnets
variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name          = string
    ip_cidr_range = string
  }))
  default = []
}

# Firewall Rules
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

# Compute Resources
variable "vms" {
  description = "List of virtual machines to create"
  type = list(object({
    name          = string
    machine_type  = string
    image_project = string
    image_family  = string
    disk_size     = number
    disk_type     = string
    network_name  = string
    subnet_name   = string
    tags          = list(string)
  }))
  default = []
}

# SSH & Access
variable "admin_ssh_keys" {
  description = "SSH keys to be added to the instances"
  type        = list(string)
  default     = []
}
