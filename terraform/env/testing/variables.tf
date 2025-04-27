# General project settings
variable "infra_version" {
  description = "Version of the overall infrastructure"
  type        = string
  default     = "0.0.1"
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
variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
  default     = "us-east1-b"
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
    prefix       = string
    roles        = list(string)
    create_key   = bool
    assign_to    = list(string)
    description  = string
  }))
}

# Subnets
variable "subnetworks" {
  description = "List of subnets to create"
  type = list(object({
    suffix        = string
    ip_cidr_range = string
    assign_to     = list(string)
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
  type        = list(object({
    id = string
    add_version = bool
  }))
}
variable "secret_values" {
  description = "Map of secret key-value pairs"
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "k8s_node_defaults" {
  description = "Default parameters of Kubernetes Nodes"
  type = object({
    machine_type        = string
    image_project       = string
    image_family        = string
    image_version       = string
    disk_size           = number
    disk_type           = string
    role                = string
    tags                = list(string)
    sa_id               = optional(string)
    cloud_init          = optional(string)
    cloud_init_data     = optional(map(string))
    startup_script      = optional(string)
    startup_script_data = optional(map(string))
  })
}
variable "k8s_nodes" {
  description = "List of Kubernetes Nodes to be created"
  type = list(object({
    name                = string
    machine_type        = optional(string)
    image_project       = optional(string)
    image_family        = optional(string)
    image_version       = optional(string)
    disk_size           = optional(number)
    disk_type           = optional(string)
    sa_id               = optional(string)
    cloud_init          = optional(string)
    cloud_init_data     = optional(map(string))
    startup_script      = optional(string)
    startup_script_data = optional(map(string))
    role                = optional(string)
    tags                = optional(list(string))
  }))
}

# SSH & Access
variable "admin_ssh_keys" {
  description = "SSH keys to be added to the instances"
  type        = list(string)
}
