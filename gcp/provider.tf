provider "google" {
  credentials = file(var.credential_filename)
  project     = var.project_id
  region      = "europe-west1"
  zone        = "europe-west1-b"
}