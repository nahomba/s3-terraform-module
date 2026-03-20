output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_url" {
  description = "S3 bucket URL"
  value       = "s3://${aws_s3_bucket.this.id}"
}

output "bucket_domain_name" {
  description = "Bucket domain name for website hosting"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "configuration" {
  description = "Bucket configuration summary"
  value = {
    environment        = var.environment
    versioning_enabled = local.versioning_enabled
    lifecycle_enabled  = local.lifecycle_enabled
    encryption_enabled = true
    public_access      = "blocked"
  }
}