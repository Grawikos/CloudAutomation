provider "google" {
  credentials = file("notional-radio-450521-a4-2f60afb9c865.json")
  project     = "notional-radio-450521-a4"
  region      = "europe-west1"
  zone        = "europe-west1-b"
}