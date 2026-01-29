variable "vpcs" {
  description = "Map of VPC definitions"
  type = map(object({
    name                    = string
    auto_create_subnetworks = optional(bool)
    delete_default_routes_on_create = optional(bool)
    routing_mode            = optional(string)
    description             = optional(string)

  }))
}

variable "subnets" {
  description = "Subnet definitions"
  type = map(object({
    name       = string
    region     = string
    cidr       = string
    vpc_key    = string
    private_ip_google_access = optional(bool)
  }))
  default = {}
}

variable "routes" {
  description = "Subnet definitions"
  type = map(object({
    name          = string
    dest_range    = string
    vpc_key       = string
    next_hop_ip   = optional(string)
    next_hop_gateway   = optional(string)
    priority      = number
  }))
  default = {}
}

variable "firewallrules" {
  description = "GCP firewall rules"
  type = map(object({
    name        = string
    vpc_key     = string
    direction   = optional(string, "INGRESS")
    priority    = optional(number, 1000)

    source_ranges      = optional(list(string))
    destination_ranges = optional(list(string))
    source_tags        = optional(list(string))
    target_tags        = optional(list(string))

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })))

    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })))
  }))
}
