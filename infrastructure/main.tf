resource "google_compute_network" "vpc_network" {
  name                    = "gke-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "gke-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region_gce
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_firewall" "allow-internal" {
  name    = "gke-allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/24"]
}

resource "google_compute_firewall" "allow-api" {
  name    = "gke-allow-api"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "${var.region_gce}-b" # zonal instead of regional

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name

  remove_default_node_pool = true
  deletion_protection      = false
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "my-node-pool"
  location = google_container_cluster.primary.location
  cluster  = google_container_cluster.primary.name

  node_count = 3

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 40
    disk_type    = "pd-standard"

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region_gce
  repository_id = "my-app-repo"
  format        = "DOCKER"
}

resource "null_resource" "ansible_loadbalancer" {
  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook ansible/get_nodes_ip.yaml --extra-vars "project_id=${var.project_id} cluster_name=${var.cluster_name} region=${var.region_gce}"
    EOT
  }

  depends_on = [google_compute_network.vpc_network, google_compute_subnetwork.subnet, google_container_node_pool.primary_nodes]
}

data "aws_caller_identity" "current" {}

module "networking" {
  source        = "./modules/networking"
  stack_name    = "MyBase"
  template_path = "AWS_CF_Templates/networking.yml"
}

module "nat" {
  source        = "./modules/NAT"
  stack_name    = "NAT"
  template_path = "AWS_CF_Templates/NAT.yml"
  depends_on    = [module.networking]
}

module "rds" {
  source        = "./modules/RDS"
  stack_name    = "RDS"
  template_path = "AWS_CF_Templates/rds.yml"
  depends_on    = [module.networking]
}

module "efs" {
  source        = "./modules/EFS"
  stack_name    = "EFS"
  template_path = "AWS_CF_Templates/efs.yml"
  depends_on    = [module.networking]
}

module "s3athena" {
  source         = "./modules/S3Athena"
  stack_name     = "S3Athena"
  template_path  = "AWS_CF_Templates/bucket.yml"
  lab_account_id = data.aws_caller_identity.current.account_id
  depends_on     = [module.networking]
}

module "ecr" {
  source        = "./modules/ECR"
  stack_name    = "ECR"
  template_path = "AWS_CF_Templates/ecr.yml"
  depends_on    = [module.networking]
}

module "buildmaster" {
  source                              = "./modules/buildInstance"
  stack_name                          = "MasterBuild"
  template_path                       = "AWS_CF_Templates/buildMaster.yml"
  depends_on                          = [module.networking, module.rds, module.s3athena, module.ecr, module.nat, aws_ssm_parameter.gcp_service_account, google_artifact_registry_repository.docker_repo]
  project_id                          = var.project_id 
  gce_service_acc_credential_filename = var.gce_service_acc_credential_filename
}

resource "time_sleep" "wait_300s" {
  create_duration = "300s"
  depends_on      = [module.buildmaster, module.rds]
}


module "appautoscaling" {
  source        = "./modules/WorkerInstances"
  stack_name    = "Instances"
  template_path = "AWS_CF_Templates/instances.yml"
  depends_on    = [time_sleep.wait_300s, module.efs]
}

module "monitoring" {
  source        = "./modules/Monitoring"
  stack_name    = "MonitoringInstance"
  template_path = "AWS_CF_Templates/MonitoringInstance.yml"
  depends_on    = [module.appautoscaling, module.networking, module.nat, module.efs]
}

resource "aws_ssm_parameter" "gcp_service_account" {
  name      = "/gcp/service-account/json"
  type      = "SecureString"
  value     = file(var.gce_service_acc_credential_filename)
  overwrite = true
}