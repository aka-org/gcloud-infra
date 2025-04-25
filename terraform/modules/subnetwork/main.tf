resource "google_compute_subnetwork" "subnetwork" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  network       = var.network
  project       = var.project_id
}

output "subnetwork_self_links" {
  value = [
    for subnet in var.subnets : {
      subnet = google_compute_subnetwork.subnetwork[subnet.name].self_link
      roles  = subnet.roles
    }
  ]
}
