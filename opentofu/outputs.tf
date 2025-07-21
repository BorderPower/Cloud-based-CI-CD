output "vm_ips" {
  value = [for vm in google_compute_instance.vm_instances : vm.network_interface[0].access_config[0].nat_ip]
}

output "vm_names" {
  value = [for vm in google_compute_instance.vm_instances : vm.name]
}
