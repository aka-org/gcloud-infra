# GCP Computing Resources Terraform Modules

This repository used modular Terraform code to provision various resources on Google Cloud Platform (GCP). 

It includes:

- 🔐 Project creation and billing setup
- 🛠️ API enabling
- 🪣 Bucket and terraform backend creation
- 🌐 VPC networking and subnet definition
- 🔥 Firewall configuration for compute engine VMs
- 🧱 Compute Engine VMs
- 📦 Modular structure for scalability and reuse

Initial Steps and Bootstrap run:

Clone the repo
```bash
git clone https://github.com/akatsantonis/gcloud_infra.git
```

Export the following terraform variables
```bash
export TF_VAR_project_id="myprojectid"
export TF_VAR_billing_account_id="mybillingaccountid"
export TF_VAR_bucket="mytfstatebucket"
```

Change directory to environments/bootstrap and initialize terraform
```bash
cd gcloud_infra/environments/bootstrap
terraform init
```

You can define variables in:

- terraform.tfvars
- CLI with -var
- Environment variables with TF_VAR_ prefix

See environment/bootstrap/terraform.tfvars for reference.

After configuring the variables run the following
```bash
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply -auto-approve tfplan

```

The initial bootstrap will create a Google project associated with a Google
billing account, enable the specified APIs and create the specified buckets.

If you want to use a remote backend for the terraform state, make sure to
set create_gcs_backend to true. This will generate a gcs backend.tf file
without a specified bucket name.

To migrate the terraform state to the bucket that was created, run
```bash
terraform init -backend-config="bucket=${TF_VAR_bucket}" -migrate-state

```

Alternative, you can edit the backend.tf file with the bucket name
and run the above command without setting the -backend-config value.

Type yes when prompted, finish the re-initialization and the state
will be stored remotely.

Provisioning resources to evnironments:

Environments should be placed under gcloud_infra/environments, for
reference checkout environments/testing/

If you created a bucket for remote terraform state storage make sure
to include a gcs backend in the terraform block of main.tf or as a 
seperate backend.tf file under the corresponding environment directory.

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
  backend "gcs" {
  }
...
```

Move to the environment directory and run the following to provision
the resources described in main.tf and configured in terraform.tfvars
```bash
cd gcloud_infra/environments/testing
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
```
Checkout environments/testing/terraform.tfvars for example of how to
configure resources such as VMs, subnets and firewall rules.

## 🔧 Terraform Bootstrap Variable Reference

| Variable Name                 | Description                                                   | Type        | Default       | Sensitive |
|------------------------------|---------------------------------------------------------------|-------------|---------------|-----------|
| `gcp_region`                 | The GCP region to deploy resources in                        | `string`    | "us-east1"     | No        |
| `gcp_zone`                   | The GCP zone to deploy resources in                          | `string`    | "us-east1-b"  | No        |
| `project_id`                 | The GCP project ID                                           | `string`    | ""            | ✅ Yes    |
| `project_name`               | A human-readable name for the project                        | `string`    | ""             | No        |
| `project_deletion_policy`    | Project deletion policy (e.g. PREVENT or DELETE)             | `string`    | `"PREVENT"`   | No        |
| `billing_account_id`         | Billing account ID to associate with the project             | `string`    | ""             | ✅ Yes    |
| `enable_apis`                | List of Google APIs to be enabled                            | `list(object)` | []          | No        |
| `buckets`                    | List of buckets to create                                    | `list(object)` | []         | No        |
| `create_gcs_backend`         | Set to true to initialize an empty gcs backend in the cwd    | `bool`     | false         | No         |

## 🔧 Terraform Network and Compute Variable Reference

| Variable Name                 | Description                                                   | Type        | Default       | Sensitive |
|------------------------------|---------------------------------------------------------------|-------------|---------------|-----------|
| `gcp_region`                 | The GCP region to deploy resources in                        | `string`    | "us-east1"     | No        |
| `gcp_zone`                   | The GCP zone to deploy resources in                          | `string`    | "us-east1-b"   | No        |
| `project_id`                 | The GCP project ID                                            | `string`    | ""            | ✅ Yes    |
| `network_name`              | VPC network name                                              | `string`    | ""           | No        |
| `subnets`                   | List of subnets to create (name & CIDR range)                | `list(object)` | []          | No        |
| `firewall_rules`            | List of firewall rules with protocol, ports, sources, tags   | `list(object)` | []         | No        |
| `vms`                       | List of virtual machines with config and metadata             | `list(object)` | []          | No        |
| `admin_ssh_keys`            | SSH keys to be added to the instances                        | `list(strings)`  | []             | No        |
