variable "pm_api_url" {}
variable "pm_api_token_id" {}
variable "pm_api_token_secret" {
  sensitive = true
}

variable "target_node" {}
variable "vm_name" {}
variable "storage" {}
variable "bridge" {}
variable "model" {}
variable "clone_id" {}

variable "vm_ip" {}
variable "vm_cidr" {}
variable "vm_gateway" {}

variable "ssh_key_path" {}
variable "ci_user" {
  default = "ubuntu"
}


