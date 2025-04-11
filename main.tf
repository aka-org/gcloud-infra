terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

module "project" {
  source                  = "./modules/project"
  project_id              = var.project_id
  project_name            = var.project_name
  project_deletion_policy = var.project_deletion_policy
  billing_account_id      = var.billing_account_id
  admin_ssh_keys          = var.admin_ssh_keys
}

module "network" {
  source                   = "./modules/network"
  network_name             = var.network_name
  k8s_subnet_name          = var.k8s_subnet_name
  k8s_ip_cidr_range        = var.k8s_ip_cidr_range
  k8s_master_firewall_name = var.k8s_master_firewall_name
  k8s_master_ports         = var.k8s_master_ports
  k8s_master_tags          = var.k8s_master_tags
  k8s_worker_firewall_name = var.k8s_worker_firewall_name
  k8s_worker_tags          = var.k8s_worker_tags
  k8s_worker_ports         = var.k8s_worker_ports
  management_firewall_name = var.management_firewall_name
  management_ports         = var.management_ports
  management_source_ranges = var.management_source_ranges
  management_tags          = var.management_tags
  depends_on               = [module.project]
}

module "kubernetes_cluster" {
  source                 = "./modules/kubernetes_cluster"
  vm_master_count        = var.vm_master_count
  vm_worker_count        = var.vm_worker_count
  vm_master_machine_type = var.vm_master_machine_type
  vm_worker_machine_type = var.vm_worker_machine_type
  vm_image_family        = var.vm_image_family
  vm_image_project       = var.vm_image_project
  vm_master_disk_size    = var.vm_master_disk_size
  vm_master_disk_type    = var.vm_master_disk_type
  vm_worker_disk_size    = var.vm_worker_disk_size
  vm_worker_disk_type    = var.vm_worker_disk_type
  vm_master_tags         = var.vm_master_tags
  vm_worker_tags         = var.vm_worker_tags
  network_name           = var.network_name
  k8s_subnet_name        = var.k8s_subnet_name
  depends_on             = [module.project, module.network]
}
