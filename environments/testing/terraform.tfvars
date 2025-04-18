gcp_region   = "us-east1"
gcp_zone     = "us-east1-b"
network_name = "k8s-network-test"
subnets = [
  {
    name          = "k8s-subnet-test"
    ip_cidr_range = "10.0.2.0/24"
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
  {
    name           = "k8s-worker-1"
    machine_type   = "e2-micro"
    image_project  = "debian-cloud"
    image_family   = "debian-12"
    disk_size      = 10
    disk_type      = "pd-standard"
    network_name   = "k8s-network-test"
    subnet_name    = "k8s-subnet-test"
    sa_id          = "secret-manager-sa"
    startup_script = "scripts/setup-github-runner.sh.tpl"
    script_vars = {
      secret_id = "github-token"
    }
    tags = ["k8s-worker", "ssh", "icmp"]
  }
]
admin_ssh_keys = [
  "aka:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXCS1q9tidu+NWd4JCu+vOozjefnxTAa1hwkdizf/0M 06042025"
]
