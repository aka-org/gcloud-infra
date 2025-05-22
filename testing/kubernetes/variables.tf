variable "release" {
  description = "Release version of the infrastructure"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "env" {
  description = "Provisioned environment name (e.g., testing, prod)"
  type        = string
}

variable "region" {
  description = "GCP region for cluster resources"
  type        = string
}

variable "zone" {
  description = "GCP zone for cluster resources"
  type        = string
}

variable "ha_enabled" {
  description = "Whether high availability mode is enabled for the cluster"
  type        = bool
}

variable "images" {
  description = "Map of image families to image versions"
  type = map(string)
}

variable "subnetwork" {
  description = "Subnetwork name for the Kubernetes cluster"
  type        = string
}

variable "admin_ssh_keys" {
  description = "List of admin SSH public keys for cluster VMs"
  type        = list(string)
}
