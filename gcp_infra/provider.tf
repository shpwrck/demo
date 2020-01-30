provider "google" {
  credentials = file(var.accessfile)
  project     = var.project
  region      = var.region
  zone        = var.zone
}
