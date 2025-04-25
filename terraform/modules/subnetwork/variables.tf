# Generic project id
variable "project_id" {
  description = " The GCP Project id"
  type        = string
}
# Network
variable "network" {
  description = "Self link to VPC network"
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
