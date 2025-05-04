variable "infra_version" {
  description = "Version of the overall infrastructure"
  type        = string
  default     = "0.0.1"
}
variable "env" {
  description = "Infrastructure environment"
  type        = string
}
variable "deployment" {
  description = "Used to identify deployments with same env"
  type        = string
}
variable "infra_version" {
  description = "Infrastructure environment"
  type        = string
}
variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
  default     = "us-east1-b"
}
variable "service_accounts" {
  description = "List of available SA emails mapping to specific vm roles"
  type = list(object({
    email     = string
    assign_to = list(string)
  }))
}
# Network
variable "network" {
  description = "Self link to VPC network"
  type        = string
}
variable "subnetworks" {
  description = "List of available subnetworks mapping to specific vm roles"
  type = list(object({
    subnetwork = string
    assign_to  = list(string)
  }))
  default = []
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
    cloud_init          = string
    cloud_init_data     = map(string)
    startup_script      = string
    startup_script_data = map(string)
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
