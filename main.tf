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

module "network" {
  source         = "./modules/network"
  network_name   = var.network_name
  subnets        = var.subnets
  firewall_rules = var.firewall_rules
}

module "compute" {
  source         = "./modules/compute"
  vms            = var.vms
  admin_ssh_keys = var.admin_ssh_keys
  depends_on     = [module.network]
}
