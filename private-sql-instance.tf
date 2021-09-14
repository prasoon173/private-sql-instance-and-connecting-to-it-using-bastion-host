#put location of your terraform service account key in case you get permission denied error. I used this block as I didn't have the access to terraform apply

provider "google" {
  credentials = file("key.json")
  project = "uob-bucket"
  
}

resource "google_sql_database" "default" {
  name     = var.db_name
  instance = google_sql_database_instance.cloudsql.name
}

resource "google_sql_database_instance" "cloudsql" {
  name             = var.db_name
  project  = var.project_id
  region = var.region
  deletion_protection = false
  database_version = var.database_version
  depends_on       = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.tier
    disk_type = var.disk_type
    availability_type = var.availability_type
    activation_policy = var.activation_policy
    disk_size         = var.disk_size

    ip_configuration {
      ipv4_enabled    = false        # don't give the db a public IPv4
      private_network = google_compute_network.vpc.self_link
    }

    location_preference {
      zone = var.zone
    }

  }
}

resource "google_sql_user" "db_user" {
  name     = var.user_name
  instance = google_sql_database_instance.cloudsql.name
  password = var.user_password
}

resource "google_compute_network" "vpc" {
  name                    = var.name
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = true
}

# We need to allocate an IP block for private IPs. We want everything in the VPC
# to have a private IP. This improves security and latency, since requests to
# private IPs are routed through Google's network, not the Internet.

resource "google_compute_global_address" "private_ip_block" {
  name         = "private-ip-block"
  description  = "A block of private IP addresses that are accessible only from within the VPC."
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  # We don't specify a address range because Google will automatically assign one for us.
  prefix_length = 20 # ~4k IPs
  network       = google_compute_network.vpc.self_link
}

# This enables private services access. This makes it possible for instances
# within the VPC and Google services to communicate exclusively using internal
# IP addresses. Details here:
#   https://cloud.google.com/sql/docs/postgres/configure-private-services-access
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}
