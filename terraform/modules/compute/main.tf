locals {
  # Merge defaults with individual vm configuration
  # overriding any of the defaults that is configured on both
  tmp_vms = [
    for vm in var.vms : merge(
      var.vm_defaults,
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
         service_account = length([
           for s in var.service_accounts : s.email if contains(s.assign_to, vm.role)
         ]) > 0 ? one([
           for s in var.service_accounts : s.email if contains(s.assign_to, vm.role)
         ]) : ""
         subnetwork = one([
           for s in var.subnetworks : s.subnetwork if contains(s.assign_to, vm.role)
         ])
         image = "projects/${vm.image_project}/global/images/${vm.image_family}-${vm.image_version}"
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
    network = var.network
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

  labels = merge(
    {
      version = each.value.image_version
      env     = var.env
      role    = each.value.role
    }
  )

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
