data "google_compute_subnetwork" "this" {
  count   = var.ha_enabled ? 1 : 0
  name    = var.subnetwork
  project = var.project_id
  region  = var.region
}

locals {
  # Determine the last available ip of the network to use as vip for the lbs
  lb_vip = var.ha_enabled ? cidrhost(data.google_compute_subnetwork.this[0].ip_cidr_range, -3) : null

  lb_image = "projects/${var.project_id}/global/images/load-balancer-${var.images["load-balancer"]}"

  lb_labels = {
    env     = var.env
    role    = "kubernetes-lb"
    version = replace(var.release, ".", "-")
  }

  lb_cloud_init_data = {
    env     = var.env
    role    = "kubernetes-lb"
    version = replace(var.release, ".", "-")
    zone    = var.zone
    lb_vip  = local.lb_vip
  }

  lb_nodes = [
    {
      name = "kubernetes-lb-1"
      cloud_init_data = merge(
        local.lb_cloud_init_data, {
          lb_state = "MASTER",
          lb_prio  = "104"
        }
      )
    },
    {
      name = "kubernetes-lb-2"
      cloud_init_data = merge(
        local.lb_cloud_init_data, {
          lb_state = "BACKUP",
          lb_prio  = "103"
        }
      )
    }
  ]
}

module "load_balancers" {
  source  = "aka-org/compute/google"
  version = "0.2.0"

  project_id     = var.project_id
  sa_id          = "load-balancer-sa"
  sa_description = "Service account used by load-balancers"
  sa_roles       = ["roles/compute.instanceAdmin"]
  vms            = local.lb_nodes
  vm_defaults = {
    zone                = var.zone
    subnetwork          = var.subnetwork
    image               = local.lb_image
    labels              = local.lb_labels
    cloud_init_data     = {}
    cloud_init          = "../../cloud-init/kubernetes-lb.yaml"
    network             = "main"
    machine_type        = "e2-micro"
    disk_size           = 10
    disk_type           = "pd-standard"
    startup_script      = ""
    startup_script_data = {}
    admin_ssh_keys      = var.admin_ssh_keys
    tags                = ["ssh", "icmp", "kubernetes-lb"]
  }

  count = var.ha_enabled ? 1 : 0
}
