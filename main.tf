# Define the required provider for the project, specifying that the Proxmox provider should be sourced from telmate/proxmox at version 3.0.1-rc8.

terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

# Ensure you have created a Proxmox API Token and provide it via variables. All variables can be defined in a `terraform.tfvars` file.

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}

#Create a new VM based on the cloud-init template.

resource "proxmox_vm_qemu" "cloudinit-test" {
    name = var.vm_name
    target_node = var.target_node

    # The clone template name. 
    clone = var.clone_id

    # Activate QEMU agent for this VM
    agent = 1

    # Resources
    os_type = "cloud-init"
    cores = 2
    sockets = 1
    vcpus = 0
    memory = 2048
    scsihw = "virtio-scsi-pci"

    # Setup the disk
    disks {
        ide {
            ide2 {
                cloudinit {
                    storage = var.storage
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = 10
                    cache           = "writeback"
                    storage         = var.storage
                    #storage_type   = "rbd"
                    #iothread       = true
                    #discard        = true
                    replicate       = true
                }
            }
        }
    }

    # Setup the network interface
    network {
    	id = 0
        model = var.model
        bridge = var.bridge
    }

    # Setup the ip address.
    boot = "order=scsi0"

    # Keep in mind to use the CIDR notation for the ip.
    # ipconfig0 = "ip=dhcp"
    ipconfig0 = "ip=${var.vm_ip}/${var.vm_cidr},gw=${var.vm_gateway}"

    #Generated ssh key on host.
    sshkeys = file(var.ssh_key_path)
    
    serial {
      id   = 0
      type = "socket"
    }
    
    # Vm user and password
    
    ciuser = ci_user
    cipassword = "ubuntu"

}