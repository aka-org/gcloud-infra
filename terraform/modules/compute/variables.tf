variable "env" {
  description = "Infrastructure environment"
  type        = string
}
variable "service_account" {
  description = "Name of the service account to assign to vm"
  type        = string
  default     = ""
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
variable "image_project" {
  description = "The project id of the project where the OS Image is stored"
  type        = string
}
variable "image_versions" {
  description = "Mapping of image families to image versions used for provisioning"
  type        = map(string)
}

variable "vm_defaults" {
  description = "Default parameters of Kubernetes Nodes"
  type = object({
    name                = optional(string)
    machine_type        = string
    image_family        = string
    disk_size           = number
    disk_type           = string
    cloud_init          = string
    cloud_init_data     = map(string)
    startup_script      = string
    startup_script_data = map(string)
    role                = string
    tags                = list(string)
  })
}
variable "vms" {
  description = "List of Kubernetes Nodes to be created"
  type = list(object({
    name                = optional(string)
    machine_type        = optional(string)
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
