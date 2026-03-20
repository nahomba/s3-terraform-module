module "dev_bucket" {
  source = "../../"

  bucket_name = "my-app-dev-${random_id.suffix.hex}"
  environment = "dev"

  tags = {
    Team    = "Development"
    Purpose = "Testing"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}