<#
Notas para VM Windows temporal ArcGIS Pro Loader.

Este archivo no instala ArcGIS Pro automáticamente porque el instalador y licenciamiento dependen de My Esri / Portal / ArcGIS Online del cliente.

Pasos manuales:
1. Conectarse por RDP.
2. Instalar Google Chrome o usar Edge.
3. Descargar ArcGIS Pro desde My Esri u organización.
4. Instalar ArcGIS Pro.
5. Iniciar sesión con licencia válida.
6. Copiar Asset Package a C:\GCP\AssetPackages.
7. Crear conexión PostgreSQL con IP privada de Cloud SQL.
8. Ejecutar Apply Asset Package.

Parámetros de conexión recomendados:
Database Platform: PostgreSQL
Instance: 10.84.128.3
Database: egdb
User: dataowner
Save user/password: enabled
#>

New-Item -ItemType Directory -Path "C:\GCP\AssetPackages" -Force | Out-Null
New-Item -ItemType Directory -Path "C:\GCP\Installers" -Force | Out-Null
New-Item -ItemType Directory -Path "C:\GCP\Evidence" -Force | Out-Null

Write-Host "Directorios base creados en C:\GCP"
Write-Host "Instale ArcGIS Pro manualmente y cree la conexión privada a Cloud SQL."
