#!/usr/bin/env bash
set -euo pipefail

# Copia instaladores de ArcGIS desde un bucket GCS hacia la VM Linux.
# Ejecutar en la VM ArcGIS Enterprise.
# Requiere que la cuenta de servicio de la VM tenga permisos de lectura sobre el bucket.

BUCKET_URI="${1:-gs://arcgis-installers-lab-camilo}"
DEST_DIR="/arcgis/install/software"

sudo mkdir -p "${DEST_DIR}"
sudo chown -R arcgis:arcgis "${DEST_DIR}"

sudo -u arcgis gsutil cp "${BUCKET_URI}"/*.tar.gz "${DEST_DIR}"/

ls -lh "${DEST_DIR}"
