variable "buckets" {
  description = "Storage Buckets"
  type = map(object({
    name                                    = string
    location                                = string
    storage_class                           = string
    uniform_bucket_level_access             = bool

  }))
}