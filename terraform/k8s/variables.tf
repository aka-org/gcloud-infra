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
variable "env" {
  description = "Infrastructure environment"
  type        = string
}

variable "release" {
  description = "SemVer compliant version used to identify different releases of infra"
  type        = string
}

variable "is_active" {
  description = "Indicates whether the cluster is current active one"
  type        = bool
}

# Settings specific to provisioned infra
variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
  default     = "us-east1-b"
}
variable "provisioned" {
  description = "Specify whether to provision the described infra"
  type        = bool
  default     = false
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
variable "images" {
  description = "Mapping of image families to image versions used for provisioning"
  type        = map(string)
}
variable "k8s_node_defaults" {
  description = "Default parameters of Kubernetes Nodes"
  type = object({
    name                = optional(string)
    machine_type        = string
    image_family        = string
    disk_size           = number
    disk_type           = string
    cloud_init          = optional(string)
    cloud_init_data     = optional(map(string))
    startup_script      = optional(string)
    startup_script_data = optional(map(string))
    role                = string
    tags                = list(string)
  })
}
variable "k8s_nodes" {
  description = "List of Kubernetes Nodes to be created"
  type = list(object({
    name                = string
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
variable "lb_service_account" {
  description = "Name of the service account to assign to vm"
  type        = string
  default     = ""
}
variable "lb_node_defaults" {
  description = "Default parameters of Kubernetes Nodes"
  type = object({
    machine_type        = string
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

# Secrets
variable "secrets" {
  description = "List of Secret objects to be created"
  type = list(object({
    id          = string
    add_version = bool
  }))
}
variable "secret_values" {
  description = "Map of secret key-value pairs"
  type        = map(string)
  sensitive   = true
  default     = {}
}
