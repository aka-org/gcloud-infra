# GCP Computing Resources Terraform Modules

This repository used modular Terraform code to provision various resources on Google Cloud Platform (GCP). 

It includes:

- 🔐 Project creation and billing setup
- 🛠️ API enabling
- 🪣 Bucket and terraform backend creation
- 🛡️ Service Account Creation and role binding
- 🌐 VPC networking and subnet definition
- 🔥 Firewall configuration for compute engine VMs
- 🧱 Compute Engine VMs
- 📦 Modular structure for scalability and reuse

### Initial Steps and Bootstrap run:

First we need to run the Bootstrap procedure which is responsible
for creating a new project, setting up a billing account for the
project, enabling required APIs, creating buckets that will be used
as backend to store the terraform state and lock files and creating
a service account with appropriate role bindings to be able to create
compute resources for each environment that we want to provision.

Clone the repo
```bash
git clone https://github.com/akatsantonis/gcloud_infra.git
```

Change directory to environments/bootstrap
```bash
cd gcloud_infra/environments/bootstrap
```

Export the following terraform variables
```bash
export TF_VAR_project_id="my_project_id"
export TF_VAR_billing_account_id="my_billing_account_id"
```

Make sure to also export the following if you plan to use 
remote backend to store the bootstrap terraform state 
```bash
export TF_VAR_bucket="my_bootstrap_procedure_tfstate_bucket"
```
Define the rest of the variables in:

- terraform.tfvars

See environment/bootstrap/terraform.tfvars for reference along with
the bootstrap reference table at the end of the documentation.

If you want to create buckets for storing the terraform state and lock
file, make sure to describe sufficient buckets for the bootstrap procedure
and for each environment that you plan to provision later.

After configuring the variables run the following
```bash
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
```
The initial bootstrap run will use a local backend, create all the required
resources and generate on the current work directory a json file with the 
key of the service account user in base64 encoding, make sure to move it to
a safe location.

If create_gcs_backend is set to true, a backend.tf will be also generated
locally which is necessary for migrating the bootstrap terraform state to
its designated bucket.

To migrate the terraform state to the bucket that was created, run
```bash
terraform init -backend-config="bucket=${TF_VAR_bucket}" -migrate-state
```

Type yes when prompted, finish the re-initialization and the state
will be stored remotely.

### Provisioning resources to environments:

Environments should be placed under gcloud_infra/environments/

For reference implementation and configuration check environments/testing/

Move to the environment directory, for example
```bash
cd gcloud_infra/environments/testing
```

If you created a bucket for remote terraform state storage make sure
to include a gcs backend in the terraform block of your main.tf manifest. 

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
}
...
```

Update the corresponding env variable to have the value of the bucket
that will store the terraform state of your environment.
```bash
export TF_VAR_bucket="my_testing_tfstate_bucket"
```

Create your own main.tf using the available modules in this repo and
configure it via terraform.tfvars as necessary.

If using a remote backend for the terraform state of your environment
run the following to initialize terraform
```bash
terraform init -backend-config="bucket=${TF_VAR_bucket}"
```

If you want to use local state don't configure the backend with -backend-config.

After terraform init, proceed with applying the resources as described in the 
bootstrap procedure.

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
| `service_accounts`           | List of service accounts to be created                       | `list(object)`  | []             | No    |
| `secrets_map`                | Map of secret name => secret value                           | `map(string)`    | {}             | ✅ Yes    |

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
