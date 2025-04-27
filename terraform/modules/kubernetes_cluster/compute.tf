locals {
  vms = [
    for vm in var.vms : merge(
      var.vm_defaults,
      {
        for k, v in vm : k => v if v != null
      }
    )
  ]
}

resource "google_compute_instance" "vm" {
  for_each = { for vm in local.vms : vm.name => vm }

#  project      = var.project_id
  name         = each.value.name
  machine_type = each.value.machine_type

  boot_disk {
    initialize_params {
      image = "projects/${each.value.image_project}/global/images/${each.value.image_family}-${each.value.image_version}"
      size  = each.value.disk_size
      type  = each.value.disk_type
    }
  }

  network_interface {
    network = var.network
    subnetwork = one([
      for s in var.subnetworks : s.subnet if contains(s.roles, each.value.role)
    ])
    access_config {}
  }

  dynamic "service_account" {
    for_each = var.service_account != "" ? [1] : []
    content {
      email  = var.service_account
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
      "user-data" = templatefile("${pwd.module}/cloud-init/${each.value.cloud_init}", each.value.cloud_init_data)
    } : {}
  )

  metadata_startup_script = (
    try(each.value.startup_script, "") != ""
    ? templatefile("${var.base_path}/${each.value.startup_script}", each.value.startup_script_data)
    : null
  )
}
