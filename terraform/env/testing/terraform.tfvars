infra_version           = "v20250503"
env                     = "testing"
gcp_region              = "us-east1"
project_prefix          = "gcloud-infra"
project_deletion_policy = "DELETE"
enable_apis = [
  "compute.googleapis.com",
  "storage.googleapis.com",
  "secretmanager.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "cloudbilling.googleapis.com",
  "serviceusage.googleapis.com",
  "iam.googleapis.com"
]
tf_state_bucket = {
  location           = "us-east1"
  force_destroy      = true
  versioning_enabled = true
}
gcs_backend = true
service_accounts = [
  {
    id          = "terraform"
    description = "Service account used by Terraform for provisioning"
    roles = [
      "roles/compute.admin",
      "roles/compute.networkAdmin",
      "roles/storage.admin",
      "roles/secretmanager.admin",
      "roles/resourcemanager.projectIamAdmin",
      "roles/iam.serviceAccountUser",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountKeyAdmin"
    ]
    create_key = true
    write_key  = false
  },
  {
    id          = "load-balancer"
    description = "Service account used by Load-balancer nodes"
    roles = [
      "roles/compute.instanceAdmin"
    ]
    create_key = false
    write_key  = false
  },
  {
    id          = "k8s-node"
    description = "Service account used by K8s nodes"
    roles = [
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.secretVersionAdder",
      "roles/compute.viewer"
    ]
    create_key = false
    write_key  = false
  }
]

vpc_name = "main"
subnetworks = [
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

secrets = [
  {
    id          = "k8s-blue-secret"
    add_version = false
  },
  {
    id          = "k8s-green-secret"
    add_version = false
  }
]
