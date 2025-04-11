# Network
variable "network_name" {
  description = "VPC network name"
}
variable "k8s_subnet_name" {
  description = "Subnet nameof Kubernetes cluster"
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
