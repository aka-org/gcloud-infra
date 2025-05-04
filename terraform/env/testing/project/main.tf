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
}

provider "google" {
  region  = var.gcp_region
  alias   = "post_bootstrap"
  project = module.project.project_id
}

module "project" {
  source                  = "../../../modules/project"
  env                     = var.env
  project_prefix          = var.project_prefix
  project_deletion_policy = var.project_deletion_policy
  billing_account_id      = var.billing_account_id
  enable_apis             = var.enable_apis
  buckets                 = var.buckets
  gcs_backend             = var.gcs_backend
}

module "iam" {
  source           = "../../../modules/iam"
  service_accounts = var.service_accounts
  project_id       = module.project.project_id
  depends_on       = [module.project]

  providers = {
    google = google.post_bootstrap
  }
}
