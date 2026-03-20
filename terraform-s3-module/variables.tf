variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

variable "environment" {
  description = "Environment: dev or prod"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either 'dev' or 'prod'."
  }
}

variable "enable_versioning" {
  description = "Enable versioning (recommended for prod)"
  type        = bool
  default     = null
}

variable "enable_lifecycle" {
  description = "Enable lifecycle rules to save costs"
  type        = bool
  default     = null
}

variable "tags" {
  description = "Additional tags for the bucket"
  type        = map(string)
  default     = {}
}