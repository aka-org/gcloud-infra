data "google_compute_subnetwork" "subnetwork" {
  name = var.subnetwork
}

locals {
  # Determine the last available ip of the network to use as vip for the lbs
  lb_vip = cidrhost(data.google_compute_subnetwork.subnetwork.ip_cidr_range, -3)

  # Merge defaults with individual vm configuration
  # overriding any of the defaults that is configured on both
  tmp_k8s_nodes = [
    for node in var.k8s_nodes : merge(
      var.k8s_node_defaults,
      {
        for k, v in node : k => v if v != null
      }
    )
  ]
  tmp_lb_nodes = [
    for node in var.lb_nodes : merge(
      var.lb_node_defaults,
      {
        for k, v in node : k => v if v != null
      }
    )
  ]
  # Add extra cloud-init data based on vars of each node
  k8s_nodes = [
    for node in local.tmp_lb_nodes : merge(
      node,
      {
        cloud_init_data = merge(
          node.cloud_init_data,
          {
            env     = var.env
            role    = node.role
            version = replace(replace(var.release, ".", "_"), "-", "_")
          }
        )
      }
    )
  ]
  lb_nodes = [
    for node in local.tmp_lb_nodes : merge(
      node,
      {
        cloud_init_data = merge(
          node.cloud_init_data,
          {
            role     = node.role
            version  = replace(replace(var.release, ".", "_"), "-", "_")
            gcp_zone = var.gcp_zone
            lb_vip   = local.lb_vip
          }
        )
      }
    )
  ]
}
