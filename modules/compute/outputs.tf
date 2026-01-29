output "instances" {
  description = "Compute instances"
  value = {
    for k, vm in google_compute_instance.vm : k => {
      name        = vm.name
      id          = vm.id
      zone        = vm.zone
      internal_ip = vm.network_interface[0].network_ip
      external_ip = try(vm.network_interface[0].access_config[0].nat_ip, null)
    }
  }
}
