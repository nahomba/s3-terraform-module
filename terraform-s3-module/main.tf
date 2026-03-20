locals {
  is_prod = var.environment == "prod"
  
  versioning_enabled = var.enable_versioning != null ? var.enable_versioning : local.is_prod
  lifecycle_enabled = var.enable_lifecycle != null ? var.enable_lifecycle : local.is_prod
  
  lifecycle_rules = local.is_prod ? {
    transition_to_ia_days      = 30
    transition_to_glacier_days = 90
    expiration_days            = 365
  } : {
    transition_to_ia_days      = 0
    transition_to_glacier_days = 0
    expiration_days            = 30
  }
  
  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Name        = var.bucket_name
    },
    var.tags
  )
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = local.versioning_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = local.lifecycle_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = local.is_prod ? [1] : []
    content {
      id     = "prod-cost-optimization"
      status = "Enabled"

      transition {
        days          = local.lifecycle_rules.transition_to_ia_days
        storage_class = "STANDARD_IA"
      }

      transition {
        days          = local.lifecycle_rules.transition_to_glacier_days
        storage_class = "GLACIER"
      }

      expiration {
        days = local.lifecycle_rules.expiration_days
      }
    }
  }

  dynamic "rule" {
    for_each = local.is_prod ? [] : [1]
    content {
      id     = "dev-cleanup"
      status = "Enabled"

      expiration {
        days = local.lifecycle_rules.expiration_days
      }
    }
  }

  dynamic "rule" {
    for_each = local.versioning_enabled ? [1] : []
    content {
      id     = "cleanup-old-versions"
      status = "Enabled"

      noncurrent_version_expiration {
        noncurrent_days = local.is_prod ? 90 : 7
      }
    }
  }
}