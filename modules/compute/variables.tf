# Compute Resources
variable "vms" {
  description = "List of virtual machines to create"
  type = list(object({
    name = string
    machine_type = string
    image_project = string
    image_family = string
    disk_size = number
    disk_type = string
    network_name = string
    subnet_name  = string
    tags = list(string)
  }))
}
