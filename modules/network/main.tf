resource "google_compute_network" "vpc_network" {
  for_each                = var.vpcs
  
  name                    = each.value.name
  auto_create_subnetworks = each.value.auto_create_subnetworks
  delete_default_routes_on_create  = each.value.delete_default_routes_on_create 
}

resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnets

  name          = each.value.name
  region        = each.value.region
  ip_cidr_range = each.value.cidr

  network = google_compute_network.vpc_network[each.value.vpc_key].self_link

  # private_ip_google_access = try(each.value.private_ip_google_access, false)
}

resource "google_compute_route" "route" {
  for_each = var.routes

  name        = each.value.name
  dest_range  = each.value.dest_range
  network     = google_compute_network.vpc_network[each.value.vpc_key].self_link
  next_hop_ip = try(each.value.next_hop_ip, null)
  next_hop_gateway  = try(each.value.next_hop_gateway, null)
  priority    = each.value.priority
  depends_on  = [google_compute_subnetwork.subnet]
}

resource "google_compute_firewall" "firewall" {
  for_each = var.firewallrules

  name    = each.value.name
  network = google_compute_network.vpc_network[each.value.vpc_key].self_link

  source_ranges      = try(each.value.source_ranges, [])
  destination_ranges = try(each.value.destination_ranges, [])
  source_tags        = try(each.value.source_tags, [])
  target_tags        = try(each.value.target_tags, [])

  dynamic "allow" {
    for_each = coalesce(each.value.allow, [])
    content {
      protocol = allow.value.protocol
      ports    = try(allow.value.ports, [])
    }
  }

  dynamic "deny" {
    for_each = coalesce(each.value.deny, [])
    content {
      protocol = deny.value.protocol
      ports    = try(deny.value.ports, [])
    }
  }

  depends_on = [google_compute_network.vpc_network]
}