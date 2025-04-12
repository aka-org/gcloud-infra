# General project settings
variable "gcp_region" {
  description = "The GCP region to deploy resources in"
}
variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
  sensitive   = true
}
variable "project_name" {
  description = "A human-readable name for the project"
}
variable "project_deletion_policy" {
  description = "Project deletion policy (e.g. PREVENT or DELETE)"
  default     = "PREVENT"
}
variable "billing_account_id" {
  description = "Billing account ID to associate with the project"
  type        = string
  sensitive   = true
}

# SSH & Access
variable "admin_ssh_keys" {
  description = "SSH keys to be added to the instances"
}

# Network
variable "network_name" {
  description = "VPC network name"
}

# Subnets
variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name          = string
    ip_cidr_range = string
  }))
}

# Firewall Rules
variable "firewall_no_ports_protocols" {
  description = "Lists of protocols that do not need ports specified"
  type        = list(string)
  default     = ["icmp", "esp", "ah"]
}
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
}
