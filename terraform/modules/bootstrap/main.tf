module "project" {
  source                  = "../../modules/project"
  project_name            = var.project_name
  project_deletion_policy = var.project_deletion_policy
  billing_account_id      = var.billing_account_id
}

module "required_apis" {
  source      = "../../modules/api"
  enable_apis = var.enable_apis
  project_id  = module.project.project_id
  depends_on  = [module.project]
}

module "tfstate_gcs_backend" {
  source             = "../../modules/bucket"
  bucket             = var.tf_state_bucket
  create_gcs_backend = var.create_gcs_backend
  project_id         = module.project.project_id
  gcp_region         = var.gcp_region
  depends_on         = [module.project, module.required_apis]
}

module "terraform_service_account" {
  source          = "../../modules/service_account"
  project_id      = module.project.project_id
  service_account = var.tf_service_account
  depends_on      = [module.project, module.required_apis]
}

module "network" {
  source         = "../../modules/network"
  project_id     = module.project.project_id
  network_name   = var.network_name
  subnets        = var.subnets
  firewall_rules = var.firewall_rules
  depends_on     = [module.project, module.required_apis]
}

output "project_id" {
  value = module.project.project_id
}
output "network" {
  value = module.network.network_self_link
}
output "subnetworks" {
  value = module.network.subnetwork_self_links
}
