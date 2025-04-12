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
}

module "network" {
  source         = "./modules/network"
  network_name   = var.network_name
  subnets        = var.subnets
  firewall_rules = var.firewall_rules
  depends_on     = [module.project]
}

module "compute" {
  source         = "./modules/compute"
  vms            = var.vms
  admin_ssh_keys = var.admin_ssh_keys
  depends_on     = [module.project, module.network]
}
