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
  source                  = "../../modules/project"
  project_id              = var.project_id
  project_name            = var.project_name
  project_deletion_policy = var.project_deletion_policy
  billing_account_id      = var.billing_account_id
}

module "apis" {
  source      = "../../modules/api"
  enable_apis = var.enable_apis
  depends_on  = [module.project]
}

module "gcs_backend" {
  source             = "../../modules/gcs_backend"
  buckets            = var.buckets
  create_gcs_backend = var.create_gcs_backend
  depends_on         = [module.project,module.apis]
}

module "service_account" {
  source           = "../../modules/service_account"
  project_id       = var.project_id
  service_accounts = var.service_accounts
  depends_on       = [module.project, module.apis]
}
