resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

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
    ports = contains(var.firewall_no_ports_protocols, each.value.protocol) ? [] : each.value.ports
  }

  source_ranges = each.value.source_ranges

  target_tags = each.value.tags
}

output "network_self_link" {
  value = google_compute_network.vpc.self_link
}
