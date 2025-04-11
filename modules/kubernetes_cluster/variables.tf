# Network
variable "network_name" {
  description = "VPC network name"
}
variable "k8s_subnet_name" {
  description = "Subnet name of the Kubernetes cluster"
}

# Compute Resources
variable "vm_master_count" {
  description = "Number of Kubernetes master nodes"
  default     = 1
}
variable "vm_worker_count" {
  description = "Number of Kubernetes worker nodes"
  default     = 1
}

variable "vm_master_machine_type" {
  description = "Machine type for master nodes"
  default     = "e2-micro"
}
variable "vm_worker_machine_type" {
  description = "Machine type for worker nodes"
  default     = "e2-micro"
}

variable "vm_master_disk_size" {
  description = "Disk size for master nodes (GB)"
  default     = 10
}
variable "vm_master_disk_type" {
  description = "Disk type for master nodes"
  default     = "pd-standard"
}
variable "vm_worker_disk_size" {
  description = "Disk size for worker nodes (GB)"
  default     = 10
}
variable "vm_worker_disk_type" {
  description = "Disk type for worker nodes"
  default     = "pd-standard"
}

variable "vm_master_tags" {
  description = "Tags for master nodes"
  default     = ["k8s-master"]
}
variable "vm_worker_tags" {
  description = "Tags for worker nodes"
  default     = ["k8s-worker"]
}

# OS Image
variable "vm_image_family" {
  description = "Image family for the VM OS"
  default     = "debian-12"
}
variable "vm_image_project" {
  description = "GCP project containing the image"
  default     = "debian-cloud"
}
