output "arcgis_enterprise_public_ip" {
  value       = google_compute_address.arcgis_static_ip.address
  description = "IP pública estática de la VM ArcGIS Enterprise."
}

output "arcgis_enterprise_internal_ip" {
  value       = google_compute_instance.arcgis_enterprise.network_interface[0].network_ip
  description = "IP interna de la VM ArcGIS Enterprise."
}

output "cloudsql_private_ip" {
  value       = google_sql_database_instance.egdb.private_ip_address
  description = "IP privada de Cloud SQL PostgreSQL. Usar desde ArcGIS Server y VM Windows."
}

output "cloudsql_connection_name" {
  value       = google_sql_database_instance.egdb.connection_name
  description = "Connection name de Cloud SQL."
}

output "windows_loader_external_ip" {
  value       = var.create_windows_loader ? google_compute_instance.arcgis_pro_loader[0].network_interface[0].access_config[0].nat_ip : null
  description = "IP externa temporal de la VM Windows para RDP."
}
