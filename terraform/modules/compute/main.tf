data "google_service_account" "sa" {
  account_id = var.service_account
}

locals {
  # Merge defaults with individual vm configuration
  # overriding any of the defaults that is configured on both
  tmp_vms = length(var.vms) > 0 ? [
    for vm in var.vms : merge(
      var.vm_defaults,
      {
        for k, v in vm : k => v if v != null
      }
    )
  ] : [var.vm_defaults]
  vms = [
    for vm in local.tmp_vms : merge(
      vm,
      {
        service_account = data.google_service_account.sa.email
        subnetwork      = var.subnetwork
        image           = "projects/${var.image_project}/global/images/${vm.image_family}-${var.images[vm.image_family]}"
        labels = {
          version   = replace(var.release, ".", "_")
          image     = replace(var.images[vm.image_family], "-", "_")
          env       = var.env
          role      = vm.role
          is_active = var.is_active    
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
