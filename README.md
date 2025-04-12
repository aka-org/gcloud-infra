# GCP Kubernetes Cluster Terraform Modules

This repository used modular Terraform code to provision various resources on Google Cloud Platform (GCP). 

It includes:

- 🔐 Project creation and billing setup
- 🌐 VPC networking and subnet definition
- 🔥 Firewall configuration for compute engine VMs
- 🧱 Compute Engine VMs
- 📦 Modular structure for scalability and reuse

Usage:

You can define variables in:

- terraform.tfvars
- CLI with -var
- Environment variables with TF_VAR_ prefix

See terraform.tfvars.example for reference.

```hcl
project_id         = "your-project-id"
billing_account_id = "XXXX-XXXXXX-XXXX"
gcp_region         = "us-central1"
gcp_zone           = "us-central1-c"
network_name       = "k8s-vpc"
...
```
## 🔧 Terraform Variable Reference

| Variable Name                 | Description                                                   | Type        | Default       | Sensitive |
|------------------------------|---------------------------------------------------------------|-------------|---------------|-----------|
| `gcp_region`                 | The GCP region to deploy resources in                        | `string`    | –             | No        |
| `gcp_zone`                   | The GCP zone to deploy resources in                          | `string`    | –             | No        |
| `project_id`                 | The GCP project ID                                            | `string`    | –             | ✅ Yes    |
| `project_name`               | A human-readable name for the project                        | `string`    | –             | No        |
| `project_deletion_policy`   | Project deletion policy (e.g. PREVENT or DELETE)             | `string`    | `"PREVENT"`   | No        |
| `billing_account_id`        | Billing account ID to associate with the project             | `string`    | –             | ✅ Yes    |
| `admin_ssh_keys`            | SSH keys to be added to the instances                        | `string`    | –             | No        |
| `network_name`              | VPC network name                                              | `string`    | –             | No        |
| `subnets`                   | List of subnets to create (name & CIDR range)                | `list(object)` | –          | No        |
| `firewall_rules`            | List of firewall rules with protocol, ports, sources, tags   | `list(object)` | –          | No        |
| `vms`                       | List of virtual machines with config and metadata             | `list(object)` | –          | No        |
