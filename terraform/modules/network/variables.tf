# Network
variable "network_name" {
  description = "VPC network name"
  type        = string
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
