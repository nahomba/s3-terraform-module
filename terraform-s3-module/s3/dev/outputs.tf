output "bucket_name" {
  description = "Dev bucket name"
  value       = module.dev_bucket.bucket_name
}

output "bucket_url" {
  description = "Dev bucket URL"
  value       = module.dev_bucket.bucket_url
}

output "configuration" {
  description = "Dev bucket configuration"
  value       = module.dev_bucket.configuration
}