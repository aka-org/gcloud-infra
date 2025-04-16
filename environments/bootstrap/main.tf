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
  depends_on         = [module.project, module.apis]
}

module "service_account" {
  for_each        = { for sa in var.service_accounts : sa.display_name => sa }
  source          = "../../modules/service_account"
  sa_id           = each.value.id
  sa_display_name = each.value.display_name
  sa_project_id   = var.project_id
  sa_roles        = each.value.roles
  depends_on      = [module.project, module.apis]
}
