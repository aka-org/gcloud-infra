variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
  default     = "us-east1-b"
}
variable "env" {
  description = "Infrastructure environment"
  type        = string
}
variable "deployment_version" {
  description = "Overall deployment version"
  type        = string
}
variable "service_account" {
  description = "Name of the service account to assign to vm"
  type = string
  default = ""
}
# Network
variable "network" {
  description = "Name of VPC network"
  type        = string
}
variable "subnetwork" {
  description = "Name of subnetwork"
  type        = string
}
variable "image_version" {
  description = "Version of the os image used for vm provisioning"
  type        = string
}
variable "lb_node_defaults" {
  description = "Default parameters of Kubernetes Nodes"
  type = object({
    machine_type        = string
    image_project       = string
    image_family        = string
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
variable "lb_nodes" {
  description = "List of Kubernetes Nodes to be created"
  type = list(object({
    name                = string
    machine_type        = optional(string)
    image_project       = optional(string)
    image_family        = optional(string)
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
