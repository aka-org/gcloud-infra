# Generic Project settings
variable "project_id" {
  description = " The GCP Project id"
  type        = string
}
variable "env" {
  description = "Infrastructure environment"
  type        = string
}

# Service Account
variable "service_account" {
  description = "K8s service account to be created"
  type = object({
    id           = string
    display_name = string
    roles        = list(string)
    create_key   = bool
  })
}

# Network
variable "network" {
  description = "Self link to k8s network"
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

# Firewall Rules
variable "firewall_rules" {
  description = "List of firewall rules to create for k8s nodes"
  type = list(object({
    name          = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
    tags          = list(string)
  }))
  default = []
}

# Compute Resources
variable "node_defaults" {
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
    sa_id               = optional(string)
    cloud_init          = optional(string)
    cloud_init_data     = optional(map(string))
    startup_script      = optional(string)
    startup_script_data = optional(map(string))
  })
}
variable "master_nodes" {
  description = "List of Kubernetes Nodes to be created"
  type = list(object({
    name                = string
    machine_type        = optional(string)
    image_project       = optional(string)
    image_family        = optional(string)
    image_version       = optional(string)
    disk_size           = optional(number)
    disk_type           = optional(string)
    sa_id               = optional(string)
    cloud_init          = optional(string)
    cloud_init_data     = optional(map(string))
    startup_script      = optional(string)
    startup_script_data = optional(map(string))
    role                = optional(string)
    tags                = optional(list(string))
  }))
}
variable "worker_nodes" {
  description = "List of Kubernetes Nodes to be created"
  type = list(object({
    name                = string
    machine_type        = optional(string)
    image_project       = optional(string)
    image_family        = optional(string)
    image_version       = optional(string)
    disk_size           = optional(number)
    disk_type           = optional(string)
    sa_id               = optional(string)
    cloud_init          = optional(string)
    cloud_init_data     = optional(map(string))
    startup_script      = optional(string)
    startup_script_data = optional(map(string))
    role                = optional(string)
    tags                = optional(list(string))
  }))
}
variable "secret_id" {
  description = "Secret to be created"
  type        = string
}
variable "secret_data" {
  description = "Value of Secret"
  type        = string
  sensitive   = true
  default     = ""
}

# SSH & Access
variable "admin_ssh_keys" {
  description = "SSH keys to be added to the instances"
  type        = list(string)
}
