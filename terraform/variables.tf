variable "project_id" {
  description = "ID del proyecto GCP."
  type        = string
}

variable "region" {
  description = "Región GCP."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona GCP."
  type        = string
  default     = "us-central1-a"
}

variable "network" {
  description = "Nombre de la VPC."
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Nombre de la subnet."
  type        = string
  default     = "default"
}

variable "admin_source_ranges" {
  description = "Rangos permitidos para administración SSH/RDP. Usar IP pública /32."
  type        = list(string)
}

variable "arcgis_admin_source_ranges" {
  description = "Rangos permitidos para puertos ArcGIS. En producción restringir."
  type        = list(string)
}

variable "compute_service_account" {
  description = "Cuenta de servicio para VMs."
  type        = string
}

variable "arcgis_vm_name" {
  type    = string
  default = "arcgis-enterprise-lab"
}

variable "arcgis_machine_type" {
  type    = string
  default = "e2-standard-4"
}

variable "arcgis_linux_image" {
  type    = string
  default = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"
}

variable "arcgis_disk_size_gb" {
  type    = number
  default = 200
}

variable "arcgis_disk_type" {
  type    = string
  default = "pd-balanced"
}

variable "cloudsql_instance_name" {
  type    = string
  default = "arcgis-egdb-pg"
}

variable "cloudsql_database_version" {
  type    = string
  default = "POSTGRES_15"
}

variable "cloudsql_tier" {
  description = "Tier Cloud SQL. Para laboratorio pequeño usar db-g1-small; para cargas usar db-custom o tier superior."
  type        = string
  default     = "db-g1-small"
}

variable "cloudsql_availability_type" {
  type    = string
  default = "ZONAL"
}

variable "cloudsql_disk_size_gb" {
  type    = number
  default = 20
}

variable "cloudsql_public_ip_enabled" {
  type    = bool
  default = false
}

variable "cloudsql_authorized_networks" {
  description = "Redes autorizadas para IP pública de Cloud SQL, si se habilita."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cloudsql_pitr_enabled" {
  type    = bool
  default = true
}

variable "cloudsql_deletion_protection" {
  type    = bool
  default = true
}

variable "egdb_database_name" {
  type    = string
  default = "egdb"
}

variable "cloudsql_admin_user" {
  type    = string
  default = "arcgis-egdb-pg"
}

variable "cloudsql_admin_password" {
  description = "Password del usuario administrador Cloud SQL. Reemplazar por secreto seguro."
  type        = string
  sensitive   = true
}

variable "create_windows_loader" {
  description = "Crear VM Windows temporal para ArcGIS Pro."
  type        = bool
  default     = true
}

variable "windows_loader_vm_name" {
  type    = string
  default = "arcgis-pro-loader"
}

variable "windows_loader_machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "windows_loader_image" {
  type    = string
  default = "projects/windows-cloud/global/images/family/windows-2025"
}

variable "windows_loader_disk_size_gb" {
  type    = number
  default = 100
}
