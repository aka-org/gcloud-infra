infra_version           = "0.0.1"
env                     = "testing"
gcp_region              = "us-east1"
gcp_zone                = "us-east1-b"
project_prefix          = "gcloud-infra"
project_deletion_policy = "DELETE"
enable_apis = [
  "compute.googleapis.com",
  "storage.googleapis.com",
  "secretmanager.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "cloudbilling.googleapis.com",
  "serviceusage.googleapis.com"
]
tf_state_bucket = {
  location           = "us-east1"
  force_destroy      = true
  versioning_enabled = true
}
gcs_backend = true
service_accounts = [
  {
    prefix      = "terraform"
    description = "Service account used by Terraform"
    roles = [
      "roles/compute.admin",
      "roles/compute.networkAdmin",
      "roles/storage.objectAdmin",
      "roles/iam.serviceAccountUser",
      "roles/storage.insightsCollectorService"
    ]
    assign_to  = [],
    create_key = true
  },
  {
    prefix      = "k8s"
    description = "Service account used by k8s nodes"
    roles = [
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.secretVersionAdder",
      "roles/compute.viewer"
    ]
    assign_to  = ["k8s-worker", "k8s-master"],
    create_key = false
  }
]

subnetworks = [
  {
    suffix        = "public"
    ip_cidr_range = "10.0.2.0/24"
    assign_to     = ["k8s-worker", "k8s-master"]
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

secrets = [
  {
    id          = "k8s-secret"
    add_version = false
  }
]

k8s_node_defaults = {
  machine_type        = "e2-medium"
  image_project       = "gcloud-infra-testing-aab1735b"
  image_family        = "k8s-node"
  image_version       = "v20250427"
  disk_size           = 10
  disk_type           = "pd-standard"
  role                = ""
  tags                = []
  startup_script      = ""
  startup_script_data = {}
  cloud_init          = "k8s-join.yaml"
  cloud_init_data = {
    k8s-secret  = "k8s-secret"
    filter-env  = "testing"
    filter-role = "k8s-master"
  }
}
k8s_nodes = [
  {
    name       = "k8s-master-1"
    cloud_init = "k8s-init.yaml"
    role       = "k8s-master"
    tags       = ["ssh", "icmp", "calico-vxlan", "k8s-master", "k8s-worker"]
  },
  {
    name = "k8s-worker-1"
    role = "k8s-worker"
    tags = ["ssh", "icmp", "calico-vxlan", "k8s-worker"]
  }
]

admin_ssh_keys = [
  "aka:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXCS1q9tidu+NWd4JCu+vOozjefnxTAa1hwkdizf/0M 06042025",
  "ansible:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJI1QdTQkaL/+CRzCTUlrKHLAQWRxjVdR5Y1C0FA3o2a 06042025"
]
