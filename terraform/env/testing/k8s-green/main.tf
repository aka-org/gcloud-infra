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

module "load_balancers" {
  source          = "../../../modules/compute"
  network         = var.network
  subnetwork      = var.subnetwork
  service_account = var.lb_service_account
  vm_defaults     = var.lb_node_defaults
  vms             = local.lb_nodes
  env             = var.env
  infra_version   = var.infra_version
  image_version   = var.lb_image_version
  admin_ssh_keys  = var.admin_ssh_keys
}
