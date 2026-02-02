variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

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
