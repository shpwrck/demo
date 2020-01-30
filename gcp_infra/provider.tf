provider "google" {
  version     = "~> 3.6"
  credentials = file(var.accessfile)
  project     = var.project
  region      = var.region
  zone        = var.zone
}
