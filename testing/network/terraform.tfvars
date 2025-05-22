firewall_rules = [
  {
    name          = "allow-ssh"
    protocol      = "tcp"
    ports         = ["22"]
    source_ranges = ["0.0.0.0/0"]
    tags          = ["ssh"]
  },
  {
    name          = "allow-icmp"
    protocol      = "icmp"
    ports         = []
    source_ranges = ["0.0.0.0/0"]
    tags          = ["icmp"]
  },
  {
    name          = "kubernetes-haproxy"
    protocol      = "tcp"
    ports         = ["6443", "8081"]
    source_ranges = ["10.0.82.0/24", "10.0.81.0/24"]
    tags          = ["kubernetes-lb"]
  },
  {
    name          = "kubernetes-keepalived"
    protocol      = "112"
    ports         = []
    source_ranges = ["10.0.82.0/24", "10.0.81.0/24"]
    tags          = ["kubernetes-lb"]
  }
]
subnetworks = [
  {
    name          = "infra-public"
    region        = "us-east1"
    ip_cidr_range = "10.0.1.0/24"
  },
  {
    name          = "kubernetes-private-1"
    region        = "us-east1"
    ip_cidr_range = "10.0.81.0/24"
  },
  {
    name          = "kubernetes-private-2"
    region        = "us-east1"
    ip_cidr_range = "10.0.82.0/24"
  }
]
