# Generic project settings
variable "project_id" {
  description = " The GCP Project id"
  type        = string
}
variable "env" {
  description = "Infrastructure environment"
  type        = string
}
variable "base_path" {
  description = "DIR path relative to invocation module"
  type        = string
}
variable "service_account" {
  description = "SA to attach to the VMs"
  type        = string
  default     = ""
}
# Network
variable "network" {
  description = "Self link to VPC network"
  type        = string
}
variable "subnetworks" {
  description = "List of available subnetworks and mapping to specific vm roles"
  type = list(object({
    subnet = string
    roles  = list(string)
  }))
  default = []
}
variable "vm_defaults" {
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
    cloud_init          = optional(string)
    cloud_init_data     = optional(map(string))
    startup_script      = optional(string)
    startup_script_data = optional(map(string))
  })
}
variable "vms" {
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
