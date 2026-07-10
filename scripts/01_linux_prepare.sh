#!/usr/bin/env bash
set -euo pipefail

# Preparación base para VM Linux ArcGIS Enterprise 11.5 en GCP.
# Este script NO instala ArcGIS Enterprise. Prepara usuario, paquetes, directorios y límites.

ARCGIS_USER="arcgis"
ARCGIS_GROUP="arcgis"

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y \
  unzip \
  tar \
  gzip \
  vim \
  curl \
  wget \
  lsof \
  iputils-ping \
  locales \
  fontconfig \
  libx11-6 \
  libxext6 \
  libxi6 \
  libxtst6 \
  libxrender1 \
  libxrandr2 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxfixes3 \
  libxinerama1 \
  libnss3 \
  libasound2t64 \
  openjdk-17-jdk \
  tomcat10 \
  postgresql-client

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

if ! id "${ARCGIS_USER}" >/dev/null 2>&1; then
  groupadd --system "${ARCGIS_GROUP}" || true
  useradd --create-home --shell /bin/bash --gid "${ARCGIS_GROUP}" "${ARCGIS_USER}"
fi

mkdir -p \
  /opt/arcgis \
  /arcgis/install/software \
  /arcgis/install/extracted/server \
  /arcgis/install/extracted/portal \
  /arcgis/install/extracted/datastore \
  /arcgis/install/extracted/webadaptor \
  /arcgis/install/licenses \
  /arcgis/directories \
  /arcgis/config-store \
  /arcgis/datastore \
  /arcgis/backups \
  /arcgis/portal-content

chown -R "${ARCGIS_USER}:${ARCGIS_GROUP}" /opt/arcgis /arcgis
chmod -R 755 /opt/arcgis /arcgis

cat >/etc/security/limits.d/arcgis.conf <<LIMITS
arcgis soft nofile 65535
arcgis hard nofile 65535
arcgis soft nproc 25059
arcgis hard nproc 25059
arcgis soft stack 10240
arcgis hard stack 10240
LIMITS

# Parámetro útil para spatiotemporal/tile cache si se amplía el laboratorio.
cat >/etc/sysctl.d/99-arcgis.conf <<SYSCTL
vm.swappiness = 1
SYSCTL
sysctl --system || true

systemctl enable tomcat10 || true
systemctl restart tomcat10 || true

echo "Preparación Linux ArcGIS completada. Reiniciar sesión antes de instalar ArcGIS Enterprise."
