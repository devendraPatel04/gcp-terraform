# variable "project_id" {
#   description = "GCP Project ID"
#   type        = string
# }

variable "services" {
  description = "Cloud Run services definition"
  type = map(object({
    name   = string
    region = string
    image  = string

    public  = optional(bool)
  }))
}
