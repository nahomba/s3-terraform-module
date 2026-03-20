module "prod_bucket" {
  source = "../../"

  bucket_name = "my-app-prod-${random_id.suffix.hex}"
  environment = "prod"

  tags = {
    Team       = "Platform"
    CostCenter = "Engineering"
    Compliance = "Required"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}