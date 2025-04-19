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
  default     = ""
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
    name           = string
    machine_type   = string
    image_project  = string
    image_family   = string
    disk_size      = number
    disk_type      = string
    network_name   = string
    subnet_name    = string
    sa_id          = string
    startup_script = string
    secrets_map    = map(string)
    labels         = map(string)
    tags           = list(string)
  }))
  default = []
}

# SSH & Access
variable "admin_ssh_keys" {
  description = "SSH keys to be added to the instances"
  type        = list(string)
  default     = []
}
