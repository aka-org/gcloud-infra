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

module "secrets" {
  source        = "../modules/secrets"
  secrets       = var.secrets
  secret_values = var.secret_values

  count = var.provisioned ? 1 : 0
}

module "load_balancers" {
  source          = "../modules/compute"
  network         = var.network
  subnetwork      = var.subnetwork
  service_account = var.lb_service_account
  vm_defaults     = var.lb_node_defaults
  vms             = local.lb_nodes
  env             = var.env
  is_active       = var.is_active
  image_project   = var.project_id
  image_versions  = var.image_versions
  admin_ssh_keys  = var.admin_ssh_keys

  count = var.provisioned ? 1 : 0
}
