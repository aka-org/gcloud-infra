infra_version = "v20250503"
project_id    = "gcloud-infra-testing-aab1735b"
gcp_region    = "us-east1"
vpc_name      = "main"
subnetworks   = [
  {
    name          = "infra-public"
    ip_cidr_range = "10.0.1.0/24"
  },
  {
    name          = "k8s-green-private"
    ip_cidr_range = "10.0.81.0/24"
  },
  {
    name          = "k8s-blue-private"
    ip_cidr_range = "10.0.82.0/24"
  }
]
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
    name          = "k8s-haproxy"
    protocol      = "tcp"
    ports         = ["6443", "8081"]
    source_ranges = ["10.0.82.0/24", "10.0.81.0/24"]
    tags          = ["k8s-load-balancer"]
  },
  {
    name          = "k8s-keepalived"
    protocol      = "112"
    ports         = []
    source_ranges = ["10.0.82.0/24", "10.0.81.0/24"]
    tags          = ["k8s-load-balancer"]
  },
  {
    name          = "k8s-master"
    protocol      = "tcp"
    ports         = ["6443", "2379", "10259", "10257", "2380", "10251", "10252", "443"]
    source_ranges = ["10.0.82.0/24", "10.0.81.0/24"]
    tags          = ["k8s-master"]
  },
  {
    name          = "k8s-worker"
    protocol      = "tcp"
    ports         = ["10250"]
    source_ranges = ["10.0.82.0/24", "10.0.81.0/24"]
    tags          = ["k8s-worker"]
  },
  {
    name          = "calico-vxlan"
    protocol      = "udp"
    ports         = ["4789", "10256"]
    source_ranges = ["10.0.82.0/24", "10.0.81.0/24"]
    tags          = ["calico"]
  }
]
