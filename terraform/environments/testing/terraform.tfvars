gcp_region   = "us-east1"
gcp_zone     = "us-east1-b"
project_id   = "gcloud-infra-13042025"
network_name = "gcloud-infra-network"
subnets = [
  {
    name          = "public-subnet-test"
    ip_cidr_range = "10.0.1.0/24"
  }
]
firewall_rules = [
  {
    name          = "k8s-master"
    protocol      = "tcp"
    ports         = ["6443", "2379", "2380", "10251", "10252", "4443"]
    source_ranges = ["10.0.2.0/24"]
    tags          = ["k8s-master"]
  },
  {
    name          = "k8s-worker"
    protocol      = "tcp"
    ports         = ["10250", "10256"]
    source_ranges = ["10.0.2.0/24"]
    tags          = ["k8s-worker"]
  },
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
  }
]
vms = [
]
admin_ssh_keys = [
  "aka:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXCS1q9tidu+NWd4JCu+vOozjefnxTAa1hwkdizf/0M 06042025",
  "ansible:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJI1QdTQkaL/+CRzCTUlrKHLAQWRxjVdR5Y1C0FA3o2a 06042025"
]
