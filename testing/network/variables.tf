variable "project_id" {
  description = "The id of the host project"
  type        = string
}

variable "network_name" {
  description = "The name of the vpc network"
  type        = string
  default     = "main"
}

variable "firewall_rules" {
  description = "List of firewall rule resources to be created"
  type = list(object({
    name          = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
    tags          = list(string)
  }))
}

variable "subnetworks" {
  description = "List of subnetwork resources to be created"
  type = list(object({
    name          = string
    region        = string
    ip_cidr_range = string
  }))
}
