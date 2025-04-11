gcp_region = "us-east1"
gcp_zone   = "us-east1-b"

project_name            = "akatestnewishys"
project_deletion_policy = "DELETE"
billing_account_id      = ""
admin_ssh_keys = []

network_name             = "k8s-network-test"
k8s_subnet_name          = "k8s-subnet-test"
k8s_ip_cidr_range        = "10.0.1.0/24"
k8s_master_firewall_name = "k8s-firewall-master"
k8s_master_tags          = ["k8s-master"]
k8s_master_ports         = [6443, 2379, 2380, 10251, 10252, 4443]
k8s_worker_firewall_name = "k8s-firewall-worker"
k8s_worker_tags          = ["k8s-worker"]
k8s_worker_ports         = [10250, 10256]
management_firewall_name = "firewall-managed-server"
management_ports         = [22]
management_source_ranges = ["0.0.0.0/0"]
management_tags          = ["managed-server"]

vm_master_count        = 1
vm_worker_count        = 0
vm_master_machine_type = "e2-micro"
vm_worker_machine_type = "e2-micro"
vm_master_disk_size    = 10
vm_worker_disk_size    = 10
vm_master_disk_type    = "pd-standard"
vm_worker_disk_type    = "pd-standard"
vm_master_tags         = ["k8s-master", "managed-server"]
vm_worker_tags         = ["k8s-worker", "managed-server"]

vm_image_family  = "debian-12"
vm_image_project = "debian-cloud"
