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

module "bootstrap_project" {
  source                  = "../../modules/bootstrap"
  project_name            = var.project_name
  project_deletion_policy = var.project_deletion_policy
  billing_account_id      = var.billing_account_id
  enable_apis             = var.enable_apis
  tf_state_bucket         = var.tf_state_bucket
  create_gcs_backend      = var.create_gcs_backend
  gcp_region              = var.gcp_region
  tf_service_account      = var.tf_service_account
  network_name            = var.network_name
  subnets                 = var.subnets
  firewall_rules          = var.firewall_rules
}

module "kubernetes_cluster" {
  source          = "../../modules/kubernetes_cluster"
  project_id      = module.bootstrap_project.project_id
  network         = module.bootstrap_project.network
  subnetworks     = module.bootstrap_project.subnetworks
  node_defaults   = var.k8s_node_defaults
  master_nodes    = var.k8s_master_nodes
  worker_nodes    = var.k8s_worker_nodes
  firewall_rules  = var.k8s_firewall_rules
  service_account = var.k8s_service_account
  env             = var.env
  admin_ssh_keys  = var.admin_ssh_keys
  secret_id       = var.k8s_secret_id
  secret_data     = var.k8s_secret_data
  depends_on      = [module.bootstrap_project]
}
