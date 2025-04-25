resource "google_compute_network" "vpc" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

output "network_self_link" {
  value = google_compute_network.vpc.self_link
}
