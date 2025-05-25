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

  lb_cloud_init_data = merge(
    local.lb_labels, {
      zone   = var.zone
      lb_vip = local.lb_vip
    }
  )

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
  kubernetes_image = "projects/${var.project_id}/global/images/kubernetes-node-${var.images["kubernetes-node"]}"
  kubernetes_master_labels = {
    env     = var.env
    role    = "kubernetes-master"
    version = replace(var.release, ".", "-")
  }
  kubernetes_worker_labels = {
    env     = var.env
    role    = "kubernetes-worker"
    version = replace(var.release, ".", "-")
  }
  kubernetes_common_cloud_init_data = {
    lb_vip            = local.lb_vip
    cluster_name      = var.cluster_name
    kubernetes_secret = var.kubernetes_secret
  }
  kubernetes_master_cloud_init_data = merge(
    local.kubernetes_master_labels,
    local.kubernetes_common_cloud_init_data, {
      init_cluster = false
    }
  )
  kubernetes_worker_cloud_init_data = merge(
    local.kubernetes_worker_labels,
    local.kubernetes_common_cloud_init_data, {
      init_cluster = false
    }
  )
  kubernetes_master_nodes = [
    {
      name = "kubernetes-master-1"
      cloud_init_data = merge(
        local.kubernetes_master_labels,
        local.kubernetes_common_cloud_init_data, {
          init_cluster = true
        }
      )
    },
    {name = "kubernetes-master-2"},
    {name = "kubernetes-master-3"}
  ]
  kubernetes_worker_nodes = [
    {name = "kubernetes-worker-1"},
    {name = "kubernetes-worker-2"},
    {name = "kubernetes-worker-3"}
  ]
}

module "load_balancers" {
  source  = "aka-org/compute/google"
  version = "0.4.0"

  project_id     = var.project_id
  secrets        = []
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

module "kubernetes_master_nodes" {
  source  = "aka-org/compute/google"
  version = "0.4.0"

  project_id = var.project_id
  secrets = [
    {
      id          = var.kubernetes_secret
      add_version = false
    }
  ]
  sa_id          = "kubernetes-master-sa"
  sa_description = "Service account used by Kubernetes Master Nodes"
  sa_roles = [
    "roles/secretmanager.secretAccessor",
    "roles/secretmanager.secretVersionAdder",
    "roles/compute.viewer"
  ]
  vms = local.kubernetes_master_nodes
  vm_defaults = {
    zone                = var.zone
    subnetwork          = var.subnetwork
    image               = local.kubernetes_image
    labels              = local.kubernetes_master_labels
    cloud_init_data     = local.kubernetes_master_cloud_init_data
    cloud_init          = "../../cloud-init/kubernetes-node.yaml"
    network             = "main"
    machine_type        = "e2-medium"
    disk_size           = 10
    disk_type           = "pd-standard"
    startup_script      = ""
    startup_script_data = {}
    admin_ssh_keys      = var.admin_ssh_keys
    tags                = ["ssh", "icmp", "kubernetes-master", "calico-vxlan"]
  }
  depends_on = [
    module.load_balancers
  ]
}

module "kubernetes_worker_nodes" {
  source  = "aka-org/compute/google"
  version = "0.4.0"

  project_id     = var.project_id
  secrets        = []
  sa_id          = "kubernetes-worker-sa"
  sa_description = "Service account used by Kubernetes Worker Nodes"
  sa_roles = [
    "roles/secretmanager.secretAccessor",
    "roles/compute.viewer"
  ]
  vms = local.kubernetes_worker_nodes
  vm_defaults = {
    zone                = var.zone
    subnetwork          = var.subnetwork
    image               = local.kubernetes_image
    labels              = local.kubernetes_worker_labels
    cloud_init_data     = local.kubernetes_worker_cloud_init_data
    cloud_init          = "../../cloud-init/kubernetes-node.yaml"
    network             = "main"
    machine_type        = "e2-medium"
    disk_size           = 10
    disk_type           = "pd-standard"
    startup_script      = ""
    startup_script_data = {}
    admin_ssh_keys      = var.admin_ssh_keys
    tags                = ["ssh", "icmp", "kubernetes-worker", "calico-vxlan"]
  }

  depends_on = [
    module.kubernetes_master_nodes,
    module.load_balancers
  ]
}
