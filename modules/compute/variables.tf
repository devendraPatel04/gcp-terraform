variable "instances" {
  description = "Compute instances keyed by logical name"
  type = map(object({
    name         = string
    zone         = string
    machine_type = string

    subnet_key   = string
    network_key  = string

    tags         = optional(list(string))
    labels       = optional(map(string))

    boot_disk = object({
      image = string
      size  = optional(number, 20)
      type  = optional(string, "pd-balanced")
    })

    can_ip_forward = optional(bool, false)

    public_ip = optional(bool, false)

    metadata = optional(map(string))
    startup_script_path = optional(string)

    ssh_user  = optional(string)
    ssh_public_key = optional(string)

    service_account = optional(object({
      email  = string
      scopes = list(string)
    }))

    shielded = optional(object({
      secure_boot          = optional(bool, true)
      vtp                  = optional(bool, true)
      integrity_monitoring = optional(bool, true)
    }))
  }))
}

variable "networks" {
  description = "VPC networks from network module"
  type        = map(any)
}

variable "subnets" {
  description = "Subnets from network module"
  type        = map(any)
}
