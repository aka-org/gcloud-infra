resource "google_compute_network" "vpc" {
  name = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "k8s_subnetwork" {
  name = var.k8s_subnet_name
  ip_cidr_range = var.k8s_ip_cidr_range
  network = google_compute_network.vpc.self_link
}

resource "google_compute_firewall" "management_firewall" {
  name    = var.management_firewall_name
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = var.management_ports
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = var.management_source_ranges
  
  target_tags = var.management_tags
}

resource "google_compute_firewall" "k8s_master_firewall" {
  name    = var.k8s_master_firewall_name
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = var.k8s_master_ports
  }

  source_ranges = [google_compute_subnetwork.k8s_subnetwork.ip_cidr_range]
  
  target_tags = var.k8s_master_tags
}

resource "google_compute_firewall" "k8s_worker_firewall" {
  name    = var.k8s_worker_firewall_name
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = var.k8s_worker_ports
  }

  source_ranges = [google_compute_subnetwork.k8s_subnetwork.ip_cidr_range]

  target_tags = var.k8s_worker_tags
}
