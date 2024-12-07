provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a custom VPC network
resource "google_compute_network" "custom_vpc" {
  name = "kubernetes-vpc"
}

# Create a subnetwork for the management cluster
resource "google_compute_subnetwork" "management_subnet" {
  name          = "management-subnet"
  ip_cidr_range = "10.1.0.0/16"
  region        = var.region
  network       = google_compute_network.custom_vpc.name
}

# Create a subnetwork for the application cluster
resource "google_compute_subnetwork" "application_subnet" {
  name          = "application-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.custom_vpc.name
}

# Management cluster using the custom subnetwork
resource "google_container_cluster" "management_cluster" {
  name       = "management-cluster"
  location   = var.region
  network    = google_compute_network.custom_vpc.name
  subnetwork = google_compute_subnetwork.management_subnet.self_link

  initial_node_count = 1
  deletion_protection = false  # Disable deletion protection

  node_config {
    machine_type = "e2-small"
    disk_size_gb = 30  # Reduce disk size to 30GB
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Application cluster using the custom subnetwork
resource "google_container_cluster" "application_cluster" {
  name       = "application-cluster"
  location   = var.region
  network    = google_compute_network.custom_vpc.name
  subnetwork = google_compute_subnetwork.application_subnet.self_link

  initial_node_count = 1
  deletion_protection = false  # Disable deletion protection
  node_config {
    machine_type = "e2-small"
    disk_size_gb = 30  # Reduce disk size to 30GB
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
