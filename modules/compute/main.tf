resource "google_compute_instance" "vm" {
  for_each = var.instances

  name         = each.value.name
  zone         = each.value.zone
  machine_type = each.value.machine_type
  tags         = try(each.value.tags, null)
  labels       = try(each.value.labels, null)
  can_ip_forward = try(each.value.can_ip_forward, false)

  boot_disk {
    initialize_params {
      image = each.value.boot_disk.image
      size  = each.value.boot_disk.size
      type  = each.value.boot_disk.type
    }
  }

  network_interface {
    network    = var.networks[each.value.network_key].self_link
    subnetwork = var.subnets[each.value.subnet_key].self_link

    dynamic "access_config" {
      for_each = each.value.public_ip ? [1] : []
      content {}
    }
  }

  metadata = merge(
    {
      enable-oslogin = "FALSE"
    },
    try(each.value.metadata, {}),
    (
      each.value.ssh_user != null && each.value.ssh_public_key != null
    ) ? {
      ssh-keys = "${each.value.ssh_user}:${each.value.ssh_public_key}"
    } : {},
    each.value.startup_script_path != null ? {
      startup-script = file("${path.module}/${each.value.startup_script_path}")
    } : {}
  )

  dynamic "service_account" {
    for_each = each.value.service_account != null ? [each.value.service_account] : []
    content {
      email  = service_account.value.email
      scopes = service_account.value.scopes
    }
  }

  dynamic "shielded_instance_config" {
    for_each = each.value.shielded != null ? [each.value.shielded] : []
    content {
      enable_secure_boot          = shielded_instance_config.value.secure_boot
      enable_vtpm                 = shielded_instance_config.value.vtp
      enable_integrity_monitoring = shielded_instance_config.value.integrity_monitoring
    }
  }
}
