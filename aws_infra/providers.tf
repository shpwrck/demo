provider "aws" {
  version    = "~> 2.41"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}
