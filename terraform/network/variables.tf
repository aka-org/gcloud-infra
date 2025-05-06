# Generic project settings
variable "project_id" {
  description = "The Project id of the project to deploy resources in"
  type        = string
  default     = "us-east1"
}
variable "gcp_region" {
  description = "The GCP region to deploy resources in"
  type        = string
  default     = "us-east1"
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
