output "vpc" {
  value = google_compute_network.vpc.self_link
}

output "subnetworks" {
  value = [
    for s in local.subnetworks : {
      subnetwork = google_compute_subnetwork.subnetwork[s.name].self_link
      assign_to = s.assign_to
    }
  ]
}
