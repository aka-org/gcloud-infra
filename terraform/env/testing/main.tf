terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  region = var.gcp_region
  zone   = var.gcp_zone
}

provider "google" {
  region  = var.gcp_region
  zone    = var.gcp_zone
  alias   = "post_bootstrap"
  project = module.project.project_id
}

module "project" {
  source                  = "../../modules/project"
  env                     = var.env
  project_prefix          = var.project_prefix
  project_deletion_policy = var.project_deletion_policy
  billing_account_id      = var.billing_account_id
  enable_apis             = var.enable_apis
  tf_state_bucket         = var.tf_state_bucket
  gcs_backend             = var.gcs_backend
}

module "iam" {
  source           = "../../modules/iam"
  env              = var.env
  service_accounts = var.service_accounts
  project_id       = module.project.project_id
  depends_on       = [module.project]

  providers = {
    google = google.post_bootstrap
  }
}

module "network" {
  source         = "../../modules/network"
  env            = var.env
  subnetworks    = var.subnetworks
  firewall_rules = var.firewall_rules
  depends_on     = [module.project]

  providers = {
    google = google.post_bootstrap
  }
}

module "secrets" {
  source        = "../../modules/secrets"
  secrets       = var.secrets
  secret_values = var.secret_values
  depends_on    = [module.project]

  providers = {
    google = google.post_bootstrap
  }
}
/*
module "kubernetes_cluster" {
  source           = "../../modules/compute"
  network          = module.network.vpc
  subnetworks      = module.network.subnetworks
  service_accounts = module.iam.service_accounts
  vm_defaults      = var.k8s_node_defaults
  vms              = var.k8s_nodes
  env              = var.env
  admin_ssh_keys   = var.admin_ssh_keys
  depends_on = [
    module.project,
    module.network,
    module.secrets,
    module.iam
  ]
  providers = {
    google = google.post_bootstrap
  }
}
*/
