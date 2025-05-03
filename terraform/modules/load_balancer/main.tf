data "google_service_account" "sa" {
  account_id = var.service_account
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
}

locals {
  # Determine the last available ip of the network to use as vip for the lbs
  lb_vip = cidrhost(data.google_compute_subnetwork.subnetwork.ip_cidr_range, -3)
  # Merge defaults with individual vm configuration
  # overriding any of the defaults that is configured on both
  tmp_vms = [
    for vm in var.lb_nodes : merge(
      var.lb_node_defaults,
      {
        for k, v in vm : k => v if v != null
      }
    )
  ]
  # Add to individual configuration of VMs the corresponding
  # os image, service_account email and subnetwork
  vms = [
    for vm in local.tmp_vms : merge(
      vm,
      {
        service_account = data.google_service_account.sa.email
        subnetwork = var.subnetwork 
        image = "projects/${vm.image_project}/global/images/${vm.image_family}-${var.image_version}"
        cloud_init_data = merge(vm.cloud_init_data, {
          k8s_master_ips = []
          lb_vip = local.lb_vip
          env     = var.env
          role    = vm.role
          deployment = var.deployment_version
          gcp_zone = var.gcp_zone
        })
        labels = {
          version = var.image_version
          deployment = var.deployment_version
          env     = var.env
          role    = vm.role
        }
      }
    )
  ]
}

resource "google_compute_instance" "vm" {
  for_each = { for vm in local.vms : vm.name => vm }

  name         = each.value.name
  machine_type = each.value.machine_type

  boot_disk {
    initialize_params {
      image = each.value.image
      size  = each.value.disk_size
      type  = each.value.disk_type
    }
  }

  network_interface {
    network    = var.network
    subnetwork = each.value.subnetwork
    access_config {}
  }

  dynamic "service_account" {
    for_each = each.value.service_account != "" ? [1] : []
    content {
      email  = each.value.service_account
      scopes = ["cloud-platform"]
    }
  }

  labels = each.value.labels 
  

  lifecycle {
    ignore_changes = [network_interface[0].alias_ip_range]
  }

  tags = each.value.tags

  metadata = merge(
    {
      ssh-keys = join("\n", var.admin_ssh_keys)
    },
    each.value.cloud_init != "" ? {
      "user-data" = templatefile(
        "${path.module}/cloud-init/${each.value.cloud_init}",
        each.value.cloud_init_data
      )
    } : {}
  )

  metadata_startup_script = (
    try(each.value.startup_script, "") != ""
    ? templatefile(
      "${path.module}/scripts/${each.value.startup_script}",
      each.value.startup_script_data
    ) : null
  )
}
