# General project settings
variable "gcp_region" {
  description = "The GCP region to deploy resources in"
}
variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
  sensitive   = true
}
variable "project_name" {
  description = "A human-readable name for the project"
}
variable "project_deletion_policy" {
  description = "Project deletion policy (e.g. PREVENT or DELETE)"
  default     = "PREVENT"
}
variable "billing_account_id" {
  description = "Billing account ID to associate with the project"
  type        = string
  sensitive   = true
}

# SSH & Access
variable "admin_ssh_keys" {
  description = "SSH keys to be added to the instances"
}

# Network
variable "network_name" {
  description = "VPC network name"
}
variable "k8s_subnet_name" {
  description = "Subnet name of Kubernetes cluster"
}
variable "k8s_ip_cidr_range" {
  description = "CIDR range for the subnet of the Kubernetes cluster"
}

# Firewall
variable "k8s_master_firewall_name" {
  description = "Firewall rule name for master nodes"
}
variable "k8s_worker_firewall_name" {
  description = "Firewall rule name for worker nodes"
}
variable "management_firewall_name" {
  description = "Firewall rule name for management access"
}
variable "k8s_master_tags" {
  description = "Tags for firewall rules of master nodes"
}
variable "k8s_worker_tags" {
  description = "Tags for firewall rules of worker nodes"
}
variable "management_tags" {
  description = "Tags for firewall rules of managed nodes"
}
variable "k8s_master_ports" {
  description = "List of ports to allow on master nodes"
}
variable "k8s_worker_ports" {
  description = "List of ports to allow on worker nodes"
}
variable "management_ports" {
  description = "List of ports for management access"
}
variable "management_source_ranges" {
  description = "Source CIDR ranges allowed for management access"
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
