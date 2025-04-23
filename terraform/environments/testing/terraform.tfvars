gcp_region   = "us-east1"
gcp_zone     = "us-east1-b"
project_id   = "gcloud-infra-13042025"
network_name = "gcloud-infra-network"
subnets = [
  {
    name          = "public-subnet-test"
    ip_cidr_range = "10.0.2.0/24"
  }
]
firewall_rules = [
  {
    name          = "k8s-master"
    protocol      = "tcp"
    ports         = ["6443", "2379", "10259", "10257", "2380", "10251", "10252", "443"]
    source_ranges = ["10.0.2.0/24"]
    tags          = ["k8s-master"]
  },
  {
    name          = "k8s-worker"
    protocol      = "tcp"
    ports         = ["10250"]
    source_ranges = ["10.0.2.0/24"]
    tags          = ["k8s-worker"]
  },
  {
    name          = "calico-vxlan"
    protocol      = "udp"
    ports         = ["4789", "10256"]
    source_ranges = ["10.0.2.0/24"]
    tags          = ["calico"]
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
  {
    name                = "k8s-master-1"
    machine_type        = "e2-medium"
    image_project       = "gcloud-infra-13042025"
    image_family        = "k8s-node"
    image_version       = "v20250422"
    disk_size           = 10
    disk_type           = "pd-standard"
    network_name        = "gcloud-infra-network"
    subnet_name         = "public-subnet-test"
    sa_id               = "k8s-gcloud-sa"
    cloud_init          = "k8s-init.yaml"
    cloud_init_data     = {
      k8s-secret = "k8s-secret-test"
      label-env = "testing"
      label-role   = "k8s-master"
    }
    startup_script      = ""
    startup_script_data = {}
    labels = {
      env  = "testing"
      role = "k8s-master"
    }
    tags = ["ssh", "icmp", "calico-vxlan", "k8s-master", "k8s-worker"]
  },
  {
    name                = "k8s-worker-1"
    machine_type        = "e2-medium"
    image_project       = "gcloud-infra-13042025"
    image_family        = "k8s-node"
    image_version       = "v20250422"
    disk_size           = 10
    disk_type           = "pd-standard"
    network_name        = "gcloud-infra-network"
    subnet_name         = "public-subnet-test"
    sa_id               = "k8s-gcloud-sa"
    cloud_init          = "k8s-node.yaml"
    cloud_init_data     = {
      k8s-secret = "k8s-secret-test"
      label-env = "testing"
      label-role   = "k8s-master"
    }
    startup_script      = ""
    startup_script_data = {}
    labels = {
      env  = "testing"
      role = "k8s-worker"
    }
    tags = ["ssh", "icmp", "calico-vxlan", "k8s-worker"]
  }
]
admin_ssh_keys = [
  "aka:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXCS1q9tidu+NWd4JCu+vOozjefnxTAa1hwkdizf/0M 06042025",
  "ansible:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJI1QdTQkaL/+CRzCTUlrKHLAQWRxjVdR5Y1C0FA3o2a 06042025"
]
