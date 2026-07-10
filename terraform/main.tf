terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# APIs requeridas
resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sqladmin" {
  project = var.project_id
  service = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "servicenetworking" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_address" "arcgis_static_ip" {
  name   = "arcgis-enterprise-lab-static-ip"
  region = var.region
  depends_on = [google_project_service.compute]
}

# Reglas de firewall para ArcGIS Enterprise
resource "google_compute_firewall" "arcgis_enterprise" {
  name    = "allow-arcgis-enterprise"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "6080", "6443", "7080", "7443", "9876", "2443", "8080"]
  }

  source_ranges = var.arcgis_admin_source_ranges
  target_tags   = ["arcgis-enterprise"]
}

resource "google_compute_firewall" "ssh_admin" {
  name    = "allow-ssh-admin"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.admin_source_ranges
  target_tags   = ["arcgis-enterprise"]
}

resource "google_compute_firewall" "rdp_admin" {
  count   = var.create_windows_loader ? 1 : 0
  name    = "allow-rdp-loader-admin"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = var.admin_source_ranges
  target_tags   = ["rdp-loader"]
}

# VM Linux para ArcGIS Enterprise
resource "google_compute_instance" "arcgis_enterprise" {
  name         = var.arcgis_vm_name
  machine_type = var.arcgis_machine_type
  zone         = var.zone

  tags = ["arcgis-enterprise", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = var.arcgis_linux_image
      size  = var.arcgis_disk_size_gb
      type  = var.arcgis_disk_type
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
      nat_ip = google_compute_address.arcgis_static_ip.address
    }
  }

  metadata = {
    startup-script = file("${path.module}/../scripts/01_linux_prepare.sh")
  }

  service_account {
    email  = var.compute_service_account
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write"
    ]
  }

  depends_on = [
    google_project_service.compute,
    google_compute_firewall.arcgis_enterprise,
    google_compute_firewall.ssh_admin
  ]
}

# Private Service Access para Cloud SQL IP privada
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "cloudsql-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "projects/${var.project_id}/global/networks/${var.network}"

  depends_on = [google_project_service.servicenetworking]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = "projects/${var.project_id}/global/networks/${var.network}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

# Cloud SQL PostgreSQL
resource "google_sql_database_instance" "egdb" {
  name             = var.cloudsql_instance_name
  database_version = var.cloudsql_database_version
  region           = var.region

  settings {
    tier              = var.cloudsql_tier
    availability_type = var.cloudsql_availability_type
    disk_type         = "PD_SSD"
    disk_size         = var.cloudsql_disk_size_gb
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = var.cloudsql_public_ip_enabled
      private_network = "projects/${var.project_id}/global/networks/${var.network}"

      dynamic "authorized_networks" {
        for_each = var.cloudsql_authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = var.cloudsql_pitr_enabled
    }
  }

  deletion_protection = var.cloudsql_deletion_protection

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "egdb" {
  name     = var.egdb_database_name
  instance = google_sql_database_instance.egdb.name
}

resource "google_sql_user" "cloudsql_admin" {
  name     = var.cloudsql_admin_user
  instance = google_sql_database_instance.egdb.name
  password = var.cloudsql_admin_password
}

# VM Windows temporal para ArcGIS Pro y cargas pesadas
resource "google_compute_instance" "arcgis_pro_loader" {
  count        = var.create_windows_loader ? 1 : 0
  name         = var.windows_loader_vm_name
  machine_type = var.windows_loader_machine_type
  zone         = var.zone

  tags = ["rdp-loader"]

  boot_disk {
    initialize_params {
      image = var.windows_loader_image
      size  = var.windows_loader_disk_size_gb
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
  }

  service_account {
    email  = var.compute_service_account
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write"
    ]
  }

  depends_on = [google_compute_firewall.rdp_admin]
}
