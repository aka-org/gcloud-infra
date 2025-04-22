# Compute Resources
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = ""
}
variable "vms" {
  description = "List of virtual machines to create"
  type = list(object({
    name           = string
    machine_type   = string
    image_project  = string
    image_family   = string
    image_version  = string
    disk_size      = number
    disk_type      = string
    network_name   = string
    subnet_name    = string
    sa_id          = string
    startup_script = string
    secrets_map    = map(string)
    labels         = map(string)
    tags           = list(string)
  }))
}

# SSH & Access
variable "admin_ssh_keys" {
  description = "SSH keys to be added to the instances"
  type        = list(string)
}
