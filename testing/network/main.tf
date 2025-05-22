module "network" {
  source  = "aka-org/network/google"
  version = "0.1.0"

  project_id     = var.project_id
  network_name   = var.network_name
  subnetworks    = var.subnetworks
  firewall_rules = var.firewall_rules
}
