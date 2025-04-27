locals {
  # VPC
  vpc_name = "${var.env}-vpc"

  # Firewall Rules
  no_ports_protocols = ["icmp", "esp", "ah"]

  # Subnetworks
  subnetworks = [
    for s in var.subnetworks : {
      name          = "${var.env}-${s.suffix}"
      ip_cidr_range = s.ip_cidr_range
      assign_to     = s.assign_to
    }
  ]
}

resource "google_compute_network" "vpc" {
  name                    = local.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each = { for s in local.subnetworks : s.name => s }

  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  network       = google_compute_network.vpc.self_link
}

resource "google_compute_firewall" "firewall" {
  for_each = { for rule in var.firewall_rules : rule.name => rule }

  name    = each.value.name
  network = google_compute_network.vpc.self_link

  allow {
    protocol = each.value.protocol
    # Check if specified protocol allows to specify ports
    ports = contains(local.no_ports_protocols, each.value.protocol) ? [] : each.value.ports
  }

  source_ranges = each.value.source_ranges

  target_tags = each.value.tags
}
