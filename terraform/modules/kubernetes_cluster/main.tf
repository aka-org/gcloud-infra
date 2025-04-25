module "k8s_service_account" {
  source          = "../../modules/service_account"
  project_id      = var.project_id
  service_account = var.service_account
}

module "k8s_secret" {
  source      = "../../modules/secret"
  project_id  = var.project_id
  secret_id   = var.secret_id
  secret_data = var.secret_data
}

module "k8s_nodes_firewall" {
  source         = "../../modules/firewall"
  project_id     = var.project_id
  network        = var.network
  firewall_rules = var.firewall_rules
}

module "k8s_master" {
  source          = "../../modules/compute"
  service_account = module.k8s_service_account.email
  vms             = var.master_nodes
  vm_defaults     = var.node_defaults
  network         = var.network
  subnetworks     = var.subnetworks
  env             = var.env
  admin_ssh_keys  = var.admin_ssh_keys
  base_path       = path.module
  project_id      = var.project_id
  depends_on = [
    module.k8s_nodes_firewall,
    module.k8s_secret,
    module.k8s_service_account
  ]
}

module "k8s_worker" {
  source          = "../../modules/compute"
  service_account = module.k8s_service_account.email
  vms             = var.worker_nodes
  vm_defaults     = var.node_defaults
  network         = var.network
  subnetworks     = var.subnetworks
  env             = var.env
  admin_ssh_keys  = var.admin_ssh_keys
  base_path       = path.module
  project_id      = var.project_id
  depends_on = [
    module.k8s_master,
    module.k8s_nodes_firewall,
    module.k8s_secret,
    module.k8s_service_account
  ]
}
