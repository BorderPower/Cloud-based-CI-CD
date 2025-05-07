pm_api_url          = "your_proxmox/api2/json"
pm_api_token_id     = "your_own"
pm_api_token_secret = "your_own"

target_node    = "proxmox"                         
vm_name        = "terraform-test-vm"                                   
storage        = "local-lvm"
bridge         = "vmbr0"
model          = "virtio"
clone_id       = "VM 9000"

vm_ip          = "192.168.100.27"
vm_cidr        = 24
vm_gateway     = ""

ssh_key_path   = "~/.ssh/id_rsa.pub"
ci_user        = "ubuntu"         