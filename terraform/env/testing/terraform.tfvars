env                     = "testing"
gcp_region              = "us-east1"
gcp_zone                = "us-east1-b"
project_name            = "gcloud-infra-test"
project_deletion_policy = "DELETE"
enable_apis = [
  "compute.googleapis.com",
  "storage.googleapis.com",
  "secretmanager.googleapis.com"
]
tf_state_bucket = {
  name               = "test-tfstate"
  force_destroy      = true
  versioning_enabled = true
}
create_gcs_backend = true
tf_service_account = {
  id           = "terraform-sa"
  display_name = "terraform-sa"
  roles = [
    "roles/compute.admin",
    "roles/compute.networkAdmin",
    "roles/storage.objectAdmin",
    "roles/iam.serviceAccountUser"
  ]
  create_key = true
}

network_name = "gcloud-infra-network"
subnets = [
  {
    name          = "public-subnet"
    ip_cidr_range = "10.0.2.0/24"
    roles         = ["k8s-worker", "k8s-master"]
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
  }
]

k8s_firewall_rules = [
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
  }
]

k8s_node_defaults = {
  machine_type        = "e2-medium"
  image_project       = "gcloud-infra-13042025"
  image_family        = "k8s-node"
  image_version       = "v20250422"
  disk_size           = 10
  disk_type           = "pd-standard"
  sa_id               = "k8s-gcloud-sa"
  role                = ""
  tags                = []
  startup_script      = ""
  startup_script_data = {}
  cloud_init_data = {
    k8s-secret  = "k8s-secret-test"
    filter-env  = "testing"
    filter-role = "k8s-master"
  }
}
k8s_master_nodes = [
  {
    name       = "k8s-master-1"
    cloud_init = "k8s-init.yaml"
    role       = "k8s-master"
    tags       = ["ssh", "icmp", "calico-vxlan", "k8s-master", "k8s-worker"]
  }
]
k8s_worker_nodes = [
  {
    name       = "k8s-worker-1"
    cloud_init = "k8s-node.yaml"
    role       = "k8s-worker"
    tags       = ["ssh", "icmp", "calico-vxlan", "k8s-worker"]
  }
]
k8s_service_account = {
  id           = "k8s-sa"
  display_name = "k8s-sa"
  roles = [
    "roles/secretmanager.secretAccessor",
    "roles/secretmanager.secretVersionAdder",
    "roles/compute.viewer"
  ]
  create_key = false
}
k8s_secret_id = "k8s-test-secret"

admin_ssh_keys = [
  "aka:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXCS1q9tidu+NWd4JCu+vOozjefnxTAa1hwkdizf/0M 06042025",
  "ansible:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJI1QdTQkaL/+CRzCTUlrKHLAQWRxjVdR5Y1C0FA3o2a 06042025"
]
