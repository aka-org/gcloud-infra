resource "google_compute_instance" "master" {
  count        = var.vm_master_count
  name         = "k8s-master-${count.index + 1}"
  machine_type = var.vm_master_machine_type

  boot_disk {
    initialize_params {
      image = "${var.vm_image_project}/${var.vm_image_family}"
      size  = var.vm_master_disk_size
      type  = var.vm_master_disk_type
    }
  }

  network_interface {
    network = var.network_name
    subnetwork = var.k8s_subnet_name
    access_config {}
  }

  tags = var.vm_master_tags
}

resource "google_compute_instance" "worker" {
  count        = var.vm_worker_count
  name         = "k8s-worker-${count.index + 1}"
  machine_type = var.vm_worker_machine_type

  boot_disk {
    initialize_params {
      image = "${var.vm_image_project}/${var.vm_image_family}"
      size  = var.vm_worker_disk_size
      type  = var.vm_worker_disk_type
    }
  }

  network_interface {
    network = var.network_name
    subnetwork = var.k8s_subnet_name
    access_config {}
  }

  tags = var.vm_worker_tags
}
