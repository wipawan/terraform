terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0" # or the latest stable
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  
  # If you're using Application Default Credentials (ADC),
  # Terraform will pick them up automatically.
  #
  # Or if you want to specify a service account key:
  # credentials = file("path/to/service-account.json")
}

# 1) Create a custom VPC network (no auto subnet creation)
resource "google_compute_network" "default" {
  name                    = var.network_name
  project                 = var.project_id
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

# 2) Create a subnetwork within that VPC
resource "google_compute_subnetwork" "default" {
  name          = var.network_name
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.default.self_link
  ip_cidr_range = "10.0.0.0/24"
}

# 3) Create a firewall rule to allow tcp (port 22 and 80) into the network (optional but often needed)
resource "google_compute_firewall" "allow_my_traffic" {
  name    = "firewall-rule"
  project = var.project_id
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  # Adjust the CIDR range as needed.
  source_ranges = [var.source_id]
}

# 4) Create an Ubuntu VM attached to the custom VPC/subnet
resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = "e2-medium"
  zone         = var.zone

  # Boot disk with an Ubuntu image
  boot_disk {
    initialize_params {
      image = var.os_type
      size  = 32
      type  = "pd-ssd"
    }
  }

  # Attach to the custom VPC and subnetwork
  network_interface {
    network    = google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.default.self_link
    # Gives the VM a public IP. Comment this out if you only want private IPs.
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt update -y

    # Install Node.js and npm
    sudo apt install -y curl
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
    sudo apt install -y nodejs

    # Install pm2 process manager
    sudo npm install -g pm2

    # Create a directory for the app
    mkdir -p /home/nodeapp
    cd /home/nodeapp

    # Create a simple Node.js app
    cat <<EOT > index.js
    const express = require('express');
    const app = express();
    app.get('/', (req, res) => {
      console.log('Hello world from console!');
      res.send('Hello from Compute Engine!');
    });
    app.listen(80, () => console.log('Server running'));
    EOT

    # Create package.json
    cat <<EOT > package.json
    {
      "name": "node-app",
      "version": "1.0.0",
      "main": "index.js",
      "dependencies": {
        "express": "^4.18.2"
      },
      "scripts": {
        "start": "node index.js"
      }
    }
    EOT

    # Install dependencies
    npm install

    # Start the app with pm2 (ensures it runs on reboot)
    pm2 start index.js --name node-app
    pm2 save
    pm2 startup systemd

  EOF

  tags = ["http-server", "https-server"]
}

# Terraform will output this data once everything has been created
output "network" {
  value = google_compute_subnetwork.default.network
}

output "subnetwork_name" {
  value = google_compute_subnetwork.default.name
}

output "vm_name" {
  description = "Name of the newly created VM"
  value       = google_compute_instance.vm.name
}

output "zone" {
  description = "Zone of the newly created VM"
  value       = google_compute_instance.vm.zone
}

output "boot_disk_image" {
  description = "Image used for the VM's boot disk"
  value       = google_compute_instance.vm.boot_disk[0].initialize_params[0].image
}
