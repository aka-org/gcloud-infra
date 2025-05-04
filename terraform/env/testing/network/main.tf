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
  project = var.project_id
}

module "network" {
  source         = "../../../modules/network"
  vpc_name       = var.vpc_name
  subnetworks    = var.subnetworks
  firewall_rules = var.firewall_rules
}
