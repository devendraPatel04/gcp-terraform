output "bucket_names" {
  description = "Storage bucket names"
  value = {
    for k, v in google_storage_bucket.bucket :
    k => v.name
  }
}