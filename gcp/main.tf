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

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = var.region

  remove_default_node_pool = true
  deletion_protection      = false
  initial_node_count       = 1

  network    = "default"
  subnetwork = "default"

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "my-node-pool"
  location = google_container_cluster.primary.location
  cluster  = google_container_cluster.primary.name


  node_count = 2

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 40 # default for micro is 100GB, not needed
    disk_type    = "pd-standard"

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}


resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "my-app-repo"
  format        = "DOCKER"
}