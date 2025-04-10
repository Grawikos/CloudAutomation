provider "aws" {
  shared_credentials_files = [var.shared_credentials_file]
  region                   = var.region_aws
  profile                  = "default"
}

provider "google" {
  credentials = file(var.credential_filename)
  project     = var.project_id
  region      = "europe-west1"
  zone        = "europe-west1-b"
}