resource "google_compute_instance" "vm" {
  for_each = { for vm in var.vms : vm.name => vm}

  name         = each.value.name 
  machine_type = each.value.machine_type

  boot_disk {
    initialize_params {
      image = "${each.value.image_project}/${each.value.image_family}"
      size  = each.value.disk_size
      type  = each.value.disk_type
    }
  }

  network_interface {
    network = each.value.network_name
    subnetwork = each.value.subnet_name
    access_config {}
  }

  tags = each.value.tags

  metadata = {
    ssh-keys = join("\n", var.admin_ssh_keys)
  }
}
