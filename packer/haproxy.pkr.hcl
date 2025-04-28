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
  default = "project_id"
}

variable "zone" {
  type = string
  default = "us-east1-b"
}

variable "image_family" {
  type = string
  default = "haproxy-node"
}

variable "subnetwork" {
  type = string
  default = "testing-public"
}

variable "network_tags" {
  type = list(string)
  default = ["ssh"]
}


source "googlecompute" "debian" {
  project_id         = var.project_id
  source_image       = "debian-12-bookworm-v20250415"
  source_image_project_id = ["debian-cloud"]
  zone               = var.zone
  machine_type       = "e2-micro"
  disk_size          = 10 
  image_name         = "${var.image_family}-v${formatdate("YYYYMMDD", timestamp())}"
  image_family       = var.image_family
  communicator       = "ssh"
  temporary_key_pair_type = "ed25519"
  ssh_username       = "packer"
  subnetwork         = var.subnetwork 
  tags               = var.network_tags
  
  image_labels = {
    version     = "v${formatdate("YYYYMMDD",timestamp())}"
    created_by  = "packer"
  }
}

build {
  sources = ["source.googlecompute.debian"]

  provisioner "shell" {
    script = "scripts/common.sh"
    execute_command = "sudo bash '{{.Path}}'"
  }

  provisioner "shell" {
    script = "scripts/install-haproxy.sh"
    execute_command = "sudo bash '{{.Path}}'"
  }

  provisioner "shell" {
    script = "scripts/clean.sh"
    execute_command = "sudo bash '{{.Path}}'"
  }
}
