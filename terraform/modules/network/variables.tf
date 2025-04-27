# Generic project settings
variable "env" {
  description = "Infrastructure environment"
  type        = string
  default     = ""
}

# Subnets
variable "subnetworks" {
  description = "List of subnets to create"
  type = list(object({
    suffix        = string
    ip_cidr_range = string
    assign_to     = list(string)
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
