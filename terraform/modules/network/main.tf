module "vpc" {
  source       = "../../modules/vpc"
  project_id   = var.project_id
  network_name = var.network_name
}

module "subnetwork" {
  source     = "../../modules/subnetwork"
  subnets    = var.subnets
  project_id = var.project_id
  network    = module.vpc.network_self_link
  depends_on = [module.vpc]
}

module "firewall" {
  source         = "../../modules/firewall"
  project_id     = var.project_id
  firewall_rules = var.firewall_rules
  network        = module.vpc.network_self_link
  depends_on     = [module.vpc]
}

output "network_self_link" {
  value = module.vpc.network_self_link
}

output "subnetwork_self_links" {
  value = module.subnetwork.subnetwork_self_links
}
