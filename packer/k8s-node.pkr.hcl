packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = ">= 1.0.0"
    }
  }
}

variable "project_id" {
  type = string
  default = ""
}

variable "zone" {
  type = string
  default = "us-east1-b"
}

variable "image_name" {
  type = string
  default = "k8s-node"
}

variable "image_version" {
  type = string
  default = "1.0.0"
}

variable "subnetwork" {
  type = string
  default = "public-subnet-test"
}

variables "network_tags" {
  type = list
  default = ["ssh"]
}


source "googlecompute" "ubuntu" {
  project_id         = var.project_id
  source_image       = "debian-12-bookworm-v20250415"
  source_image_project_id = "debian-cloud"
  zone               = var.zone
  machine_type       = "e2-micro"
  disk_size          = 20
  image_name         = "${var.image_name}-${formatdate("YYYYMMDDhhmm", timestamp())}"
  communicator       = "ssh"
  temporary_key_pair_type = "ed25519"
  ssh_username       = "packer"
  subnetwork         = var.subnetwork 
  tags               = var.network_tags
  
  image_labels = {
    version     = var.version
    created_by  = "packer"
  }
}

build {
  sources = ["source.googlecompute.debian"]

  provisioner "shell" {
    scripts = [
      "../scripts/common.sh",
      "../scripts/install-k8s.sh"
    ]
  }

  provisioner "shell" {
    script = "../scripts/clean.sh"
  }
}
