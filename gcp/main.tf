resource "google_compute_network" "vpc_network" {
  name                    = "k8s-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "k8s-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "europe-west1"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_firewall" "allow-internal" {
  name    = "k8s-allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/24"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "k8s-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "kubemaster" {
  name         = "kubemaster"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}
  }

  tags = ["k8s"]
}

resource "google_compute_instance" "node1" {
  name         = "node1"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}
  }

  tags = ["k8s"]
}

resource "google_artifact_registry_repository" "docker_repo" {
  location      = "europe-west1"
  repository_id = "my-app-repo"
  format        = "DOCKER"
}