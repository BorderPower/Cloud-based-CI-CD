variable "project_id" {}
variable "region" {
  default = "europe-west1"
}
variable "zone" {
  default = "europe-west1-b"
}

variable "network_name" {
  default = "custom-vpc-network"
}

variable "vm_names" {
  type    = list(string)
}

variable "machine_type" {
  default = "e2-medium"
}

variable "boot_image" {
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "boot_disk_size_gb" {
  default = 20
}

variable "boot_disk_type" {
  default = "pd-standard"
}

variable "ssh_user" {
  description = "SSH username"
}

variable "ssh_public_key" {
  description = "Public ssh key content (~/.ssh/id_rsa.pub)"
}
