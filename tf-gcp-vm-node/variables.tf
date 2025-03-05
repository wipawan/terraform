variable "region" {
    description = "The Project ID you wish to deploy into"
}
variable "zone" {
    description = "The zone within a region to use" 
}
variable "location" {
    description = "Zone removed use location instead error"
}
variable "project_id" {
    description = "The Project to launch into"
}
variable "network_name" {
  description = "Creates name for Network and Cluster"
}
variable "name" {
    description = "Setting a name for resources to use"
}

variable "source_id" {
  type        = string
  description = "CIDR range allowed to access into the VM (e.g., x.x.x.x/32 for your public IP)"
  default     = "0.0.0.0/0"  # <-- You can override this in terraform.tfvars or via -var on CLI
}

variable "synthetic_ips" {
  default = [
      "3.1.36.99/32",
      "3.1.219.207/32",
      "3.18.172.189/32",
      "3.18.188.104/32",
      "3.18.197.0/32",
      "3.35.66.96/32",
      "3.36.177.119/32",
      "3.92.150.182/32",
      "3.96.7.126/32",
      "3.120.223.25/32",
      "3.121.24.234/32",
      "13.48.150.244/32",
      "13.48.239.118/32",
      "13.48.254.37/32",
      "13.54.169.48/32",
      "13.114.211.96/32",
      "13.115.46.213/32",
      "13.126.169.175/32",
      "13.208.126.217/32",
      "13.208.133.55/32",
      "13.208.142.17/32",
      "13.208.255.200/32",
      "13.209.118.42/32",
      "13.209.230.111/32",
      "13.234.54.8/32",
      "13.236.246.161/32",
      "13.238.14.57/32",
      "13.244.85.86/32",
      "13.244.188.203/32",
      "13.245.194.43/32",
      "13.245.200.254/32",
      "13.246.172.210/32",
      "13.247.164.9/32",
      "15.152.238.192/32",
      "15.161.86.71/32",
      "15.165.240.116/32",
      "15.168.188.85/32",
      "15.184.139.182/32",
      "15.185.189.82/32",
      "15.188.202.64/32",
      "15.188.240.172/32",
      "15.188.243.248/32",
      "16.24.38.13/32",
      "16.24.60.114/32",
      "16.162.136.62/32",
      "16.163.153.45/32",
      "18.102.80.189/32",
      "18.130.113.168/32",
      "18.139.52.173/32",
      "18.163.21.55/32",
      "18.163.59.106/32",
      "18.166.19.255/32",
      "18.195.155.52/32",
      "18.200.120.237/32",
      "18.229.28.50/32",
      "18.229.36.120/32",
      "20.62.248.141/32",
      "20.83.144.189/32",
      "34.48.76.208/29",
      "34.94.234.88/29",
      "34.145.82.128/29",
      "34.146.154.144/29",
      "34.159.50.128/29",
      "34.174.98.16/29",
      "34.208.32.189/32",
      "35.152.76.8/32",
      "35.154.93.182/32",
      "35.176.195.46/32",
      "35.177.43.250/32",
      "40.76.107.170/32",
      "43.198.123.228/32",
      "43.203.72.233/32",
      "43.218.5.202/32",
      "52.9.13.199/32",
      "52.9.139.134/32",
      "52.35.61.232/32",
      "52.55.56.26/32",
      "52.60.189.53/32",
      "52.67.95.251/32",
      "52.89.221.151/32",
      "52.192.175.207/32",
      "54.177.155.33/32",
      "63.34.100.178/32",
      "63.35.33.198/32",
      "99.79.87.237/32",
      "107.21.25.247/32",
      "108.137.133.223/32",
      "108.137.188.57/32",
      "157.241.36.106/32",
      "157.241.93.102/32"
    ]
}

variable "vm_name" {
  type        = string
  description = "VM name"
  default     = "mew-ubuntu-vm"
}

variable "os_type" {
  type        = string
  description = <<EOT
Select which OS to use. Valid options (in this example):
  - "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
  - "projects/centos-cloud/global/images/family/centos-9"
  - "projects/rhel-cloud/global/images/family/rhel-9"
  - "projects/windows-cloud/global/images/family/windows-2022"
EOT
  default = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
}

