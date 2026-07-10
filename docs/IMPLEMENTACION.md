# Guía de implementación automática parcial en GCP

## 1. Objetivo

Este paquete permite crear automáticamente parte de la infraestructura base usada en el laboratorio:

- VM Linux para ArcGIS Enterprise.
- Reglas de firewall.
- IP pública estática.
- Cloud SQL PostgreSQL con IP privada.
- Base `egdb`.
- Usuario administrador Cloud SQL.
- VM Windows temporal para ArcGIS Pro.

La instalación de ArcGIS Enterprise, autorización de licencias, creación de Portal, federación y configuración de Utility Network permanecen como pasos manuales/asistidos porque dependen de instaladores, licencias y credenciales del cliente.

---

## 2. Prerrequisitos

- Proyecto GCP activo.
- Billing habilitado.
- Terraform instalado.
- Google Cloud SDK instalado.
- Permisos para crear Compute Engine, Cloud SQL, VPC peering y firewall.
- Instaladores oficiales de Esri.
- Archivos de licencia `.ecp` y JSON de Portal.
- Asset Package de Utility Network.

---

## 3. Uso de Terraform

### 3.1 Inicializar

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Editar `terraform.tfvars` y ajustar:

```hcl
project_id = "ID_DEL_PROYECTO"
admin_source_ranges = ["IP_PUBLICA_ADMIN/32"]
arcgis_admin_source_ranges = ["IP_PUBLICA_ADMIN/32"]
cloudsql_admin_password = "PASSWORD_SEGURO"
```

### 3.2 Plan

```bash
terraform init
terraform plan
```

### 3.3 Aplicar

```bash
terraform apply
```

### 3.4 Obtener salidas

```bash
terraform output
```

Salidas importantes:

- `arcgis_enterprise_public_ip`
- `arcgis_enterprise_internal_ip`
- `cloudsql_private_ip`
- `windows_loader_external_ip`

---

## 4. Preparación Cloud SQL

Conectarse a la base `egdb` y ejecutar:

```bash
psql "host=IP_PRIVADA_CLOUDSQL port=5432 dbname=egdb user=USUARIO_ADMIN sslmode=require" -f scripts/03_prepare_cloudsql_postgis.sql
```

Luego preparar `sde`:

```bash
psql "host=IP_PRIVADA_CLOUDSQL port=5432 dbname=egdb user=USUARIO_ADMIN sslmode=require" -f scripts/04_prepare_sde_role.sql
```

Después ejecutar **Enable Enterprise Geodatabase** desde ArcGIS Pro con conexión como `sde`.

---

## 5. Instalación ArcGIS Enterprise

En la VM Linux:

```bash
sudo -u arcgis gsutil cp gs://BUCKET/*.tar.gz /arcgis/install/software/
```

Instalar manualmente:

- ArcGIS Server.
- Portal for ArcGIS.
- ArcGIS Data Store.
- Web Adaptor Java.

Luego:

- Autorizar ArcGIS Server.
- Crear site.
- Crear Portal.
- Configurar Data Store.
- Registrar Web Adaptors.
- Federar Server.
- Configurar Hosting Server.

---

## 6. Carga Utility Network

En VM Windows:

1. Instalar ArcGIS Pro.
2. Crear conexión a Cloud SQL con IP privada.
3. Crear usuario `dataowner` desde ArcGIS Pro.
4. Ejecutar Stage Utility Network.
5. Ejecutar Apply Asset Package.
6. Registrar Data Store en ArcGIS Server.
7. Publicar servicio.
8. Probar trace, edición y validate.

---

## 7. Limpieza

Al terminar:

- Apagar o eliminar VM Windows temporal.
- Deshabilitar IP pública de Cloud SQL si se habilitó.
- Rotar contraseñas.
- Crear respaldo de Cloud SQL.
- Exportar documentación/evidencias.

---

## 8. Comandos útiles

### Cambiar tamaño de Cloud SQL temporalmente

```bash
gcloud sql instances patch arcgis-egdb-pg --tier=db-custom-2-8192
```

### Apagar VM Windows

```bash
gcloud compute instances stop arcgis-pro-loader --zone=us-central1-a
```

### Encender VM Windows

```bash
gcloud compute instances start arcgis-pro-loader --zone=us-central1-a
```

### Eliminar VM Windows

```bash
gcloud compute instances delete arcgis-pro-loader --zone=us-central1-a
```
