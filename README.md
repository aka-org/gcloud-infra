# GCP Kubernetes Cluster Terraform Modules

This repository provisions a complete Kubernetes cluster setup
on Google Cloud Platform (GCP) using modular Terraform code. 

It includes:

- 🔐 Project creation and billing setup
- 🌐 VPC networking and subnet definition
- 🔥 Firewall configuration for cluster components
- 🧱 Compute Engine VMs for Kubernetes master and worker nodes
- 📦 Modular structure for scalability and reuse

Usage:

You can define variables in:

- terraform.tfvars
- CLI with -var
- Environment variables with TF_VAR_ prefix

See terraform.tfvars.example for reference.
'''
project_id         = "your-project-id"
billing_account_id = "XXXX-XXXXXX-XXXX"
gcp_region         = "us-central1"
gcp_zone           = "us-central1-c"
network_name       = "k8s-vpc"
...
'''

## 🔧 Terraform Variable Reference

---

### 🌍 General Project Settings

| Variable Name             | Type      | Description                                                      |
|--------------------------|-----------|------------------------------------------------------------------|
| `gcp_region`             | string    | The GCP region to deploy resources in                            |
| `gcp_zone`               | string    | The GCP zone to deploy resources in                              |
| `project_id`             | string    | The GCP project ID                                               |
| `project_name`           | string    | A human-readable name for the project                            |
| `project_deletion_policy`| string    | Project deletion policy (`PREVENT` or `DELETE`)                  |
| `billing_account_id`     | string    | Billing account ID to associate with the project                 |
| `admin_ssh_keys`         | string or list(string) | SSH keys to be added to the instances                  |

---

### 🌐 Network Configuration

| Variable Name             | Type      | Description                                                      |
|--------------------------|-----------|------------------------------------------------------------------|
| `network_name`           | string    | VPC network name                                                 |
| `k8s_subnet_name`        | string    | Subnet name of Kubernetes cluster                                |
| `k8s_ip_cidr_range`      | string    | CIDR range for the subnet of the Kubernetes cluster              |

---

### 🔥 Firewall Configuration

| Variable Name                  | Type          | Description                                                      |
|-------------------------------|---------------|------------------------------------------------------------------|
| `k8s_master_firewall_name`    | string        | Firewall rule name for master nodes                              |
| `k8s_worker_firewall_name`    | string        | Firewall rule name for worker nodes                              |
| `management_firewall_name`    | string        | Firewall rule name for management access                         |
| `k8s_master_tags`             | list(string)  | Tags for firewall rules of master nodes                          |
| `k8s_worker_tags`             | list(string)  | Tags for firewall rules of worker nodes                          |
| `management_tags`             | list(string)  | Tags for firewall rules of managed nodes                         |
| `k8s_master_ports`            | list(string)  | List of ports to allow on master nodes (e.g. `["22", "6443"]`)   |
| `k8s_worker_ports`            | list(string)  | List of ports to allow on worker nodes (e.g. `["22", "10250"]`)  |
| `management_ports`            | list(string)  | List of ports for management access                              |
| `management_source_ranges`    | list(string)  | Source CIDR ranges allowed for management access                 |

---

### 🧱 Compute Resources – Kubernetes Nodes

| Variable Name              | Type          | Description                                                      |
|---------------------------|---------------|------------------------------------------------------------------|
| `vm_master_count`         | number        | Number of Kubernetes master nodes                                |
| `vm_worker_count`         | number        | Number of Kubernetes worker nodes                                |
| `vm_master_machine_type`  | string        | Machine type for master nodes (e.g. `e2-micro`)                  |
| `vm_worker_machine_type`  | string        | Machine type for worker nodes (e.g. `e2-medium`)                 |
| `vm_master_disk_size`     | number        | Disk size for master nodes in GB                                 |
| `vm_master_disk_type`     | string        | Disk type for master nodes (e.g. `pd-standard`)                  |
| `vm_worker_disk_size`     | number        | Disk size for worker nodes in GB                                 |
| `vm_worker_disk_type`     | string        | Disk type for worker nodes                                       |
| `vm_master_tags`          | list(string)  | Tags for master node instances                                   |
| `vm_worker_tags`          | list(string)  | Tags for worker node instances                                   |

---

### 🖥 OS Image Configuration

| Variable Name              | Type      | Description                                                      |
|---------------------------|-----------|------------------------------------------------------------------|
| `vm_image_family`         | string    | Image family for the VM OS (e.g. `debian-12`)                    |
| `vm_image_project`        | string    | GCP project containing the image (e.g. `debian-cloud`)           |


