variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "Default GCP region"
}

variable "vpcs" {
  type = map(object({
    name                    = string
    auto_create_subnetworks = bool
    delete_default_routes_on_create = bool
  }))
}

variable "subnets" {
  type = map(object({
    name    = string
    region  = string
    cidr    = string
    vpc_key = string
  }))
}

variable "routes" {
  type = map(object({
    name        = string
    dest_range = string
    vpc_key    = string
    next_hop_ip = optional(string)
    next_hop_gateway  = optional(string)
    priority   = number
  }))
}

variable "firewallrules" {
  type = map(object({
    name      = string
    vpc_key   = string
    priority  = optional(number)

    source_ranges      = optional(list(string))
    destination_ranges = optional(list(string))
    source_tags        = optional(list(string))
    target_tags        = optional(list(string))

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])

    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
}

variable "instances" {
  description = "Compute instances"
  type = map(object({
    name         = string
    zone         = string
    machine_type = string

    network_key = string
    subnet_key  = string

    tags    = optional(list(string), [])
    labels = optional(map(string), {})

    boot_disk = object({
      image = string
      size  = optional(number, 20)
      type  = optional(string, "pd-balanced")
    })

    ssh_user  = optional(string)
    ssh_public_key = optional(string)

    public_ip      = optional(bool, false)
    startup_script_path = optional(string)

    service_account = optional(object({
      email  = string
      scopes = list(string)
    }))
  }))
}

## STorage
variable "buckets" {
  description = "Storage Buckets"
  type = map(object({
    name                                    = string
    location                                = string
    storage_class                           = string
    uniform_bucket_level_access             = bool

  }))
}

##Cloud Run
variable "cloudrun_services" {
  type = map(object({
    name   = string
    region = string
    image  = string
    public  = optional(bool)
  }))
}

##App Engine
variable "create_app_engine" {
  type        = bool
  description = "Whether to create App Engine application"
  default     = false
}

variable "app_engine_location_id" {
  type        = string
  description = "App Engine region (only used if create_app_engine = true)"
  default     = null
}

variable "app_engine_services" {
  description = "App Engine services"
  type = map(object({
    service_name = string
    runtime      = string
    version_id   = string

    entrypoint = optional(object({
      shell = string
    }))
    
    source_url   = string
    env_vars     = optional(map(string))
  }))
}
