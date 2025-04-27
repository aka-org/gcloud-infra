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
