resource "google_compute_instance" "vm" {
  for_each = { for vm in var.vms : vm.name => vm }

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
    network    = each.value.network_name
    subnetwork = each.value.subnet_name
    access_config {}
  }

  dynamic "service_account" {
    for_each = try(each.value.sa_id, "") != "" ? [1] : []

    content {
      email  = "${each.value.sa_id}@${var.project_id}.iam.gserviceaccount.com"
      scopes = ["cloud-platform"]
    }
  }

  labels = merge(each.value.labels, { version = each.value.image_version })
  tags   = each.value.tags

  metadata = merge(
    {
      ssh-keys = join("\n", var.admin_ssh_keys)
    },
    each.value.cloud_init != "" ? {
      "user-data" = templatefile("${path.module}/cloud-init/${each.value.cloud_init}", each.value.cloud_init_data)
    } : {}
  )

  metadata_startup_script = (
    try(each.value.startup_script, "") != ""
    ? templatefile("${path.module}/${each.value.startup_script}", each.value.startup_script_data)
    : null
  )

  lifecycle {
    ignore_changes = [labels["ansible_configured"]]
  }
}
