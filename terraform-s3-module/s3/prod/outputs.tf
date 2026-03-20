output "bucket_name" {
  description = "Prod bucket name"
  value       = module.prod_bucket.bucket_name
}

output "bucket_arn" {
  description = "Prod bucket ARN"
  value       = module.prod_bucket.bucket_arn
}

output "configuration" {
  description = "Prod bucket configuration"
  value       = module.prod_bucket.configuration
}