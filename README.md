# gcloud-infra

## Table of Contents
- [Purpose](#purpose)
- [Repository Structure](#repository-structure)
- [Custom Modules & Dependencies](#custom-modules--dependencies)
- [License](#license)

## Purpose
This repository provides a professional-grade Terraform composition for provisioning Google Cloud infrastructure using custom OS images and purpose-built Terraform modules. It is designed to automate the deployment of scalable, secure, and maintainable cloud environments leveraging Google Cloud VMs, custom images, and modular infrastructure-as-code practices.

The custom OS images used in this repository are built and maintained in a separate project: [gcloud-os-images](https://github.com/aka-org/gcloud-os-images).

## Repository Structure
- **cloud-init/**: Contains cloud-init configuration files for initializing VMs with custom settings and scripts during provisioning.
- **releases/**: Stores release manifests and versioned deployment artifacts for tracking and managing infrastructure releases.
- **testing/**: Includes Terraform configurations for testing infrastructure components, such as Kubernetes clusters, networking, and project-level resources. This directory is organized by logical infrastructure domains (e.g., `kubernetes/`, `network/`, `project/`).

Each subdirectory is structured to encapsulate a specific aspect of the infrastructure, promoting modularity and reusability.

## Custom Modules & Dependencies
This repository leverages custom-written Terraform modules to manage Google Cloud resources efficiently:
- [terraform-google-compute](https://github.com/aka-org/terraform-google-compute): Custom module for provisioning and managing Google Compute Engine resources.
- [terraform-google-network](https://github.com/aka-org/terraform-google-network): Custom module for defining and managing Google Cloud networking components.
- [terraform-google-project](https://github.com/aka-org/terraform-google-project): Custom module for Google Cloud project setup and management.

These modules are designed to be composable and reusable, enabling flexible infrastructure definitions tailored to specific requirements.

## License
This project is licensed under the terms of the [LICENSE](LICENSE) file included in this repository.
