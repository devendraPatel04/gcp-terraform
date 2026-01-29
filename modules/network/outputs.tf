output "vpc_ids" {
  description = "VPC network IDs keyed by VPC key"
  value = {
    for k, v in google_compute_network.vpc_network :
    k => v.id
  }
}

output "vpc_names" {
  description = "VPC network names keyed by VPC key"
  value = {
    for k, v in google_compute_network.vpc_network :
    k => v.name
  }
}

output "vpc_networks" {
  value = google_compute_network.vpc_network
}

output "subnets" {
  value = google_compute_subnetwork.subnet
}
