BITÁCORA - LABORATORIO ARCGIS ENTERPRISE + UTILITY NETWORK EN GOOGLE CLOUD

Proyecto:
- Nombre visible: My First Project
- Objetivo: preparar una VM en Google Cloud para laboratorio de ArcGIS Enterprise + Utility Network.
- Modalidad: Google Cloud Free Trial.
- Crédito inicial disponible: COP 1,031,258.
- Días disponibles del trial: 90.
- Costo inicial registrado: $0.

------------------------------------------------------------
1. Revisión del crédito gratuito
------------------------------------------------------------
Se validó en Billing que la cuenta tiene crédito gratuito activo.

Resultado:
- Crédito gratuito: COP 1,031,258.
- Días restantes: 90.
- Costo acumulado inicial: $0.
- Fecha de finalización indicada por Google: 1 de octubre de 2026.

Observación:
- El crédito gratuito permite crear recursos, pero se debe controlar el gasto porque las máquinas virtuales consumen crédito mientras estén encendidas.

------------------------------------------------------------
2. Creación de alerta de presupuesto
------------------------------------------------------------
Se creó una alerta mensual de presupuesto.

Configuración:
- Presupuesto mensual: $100,000 COP.

Resultado:
- Alerta creada correctamente.
- Google mostró advertencia indicando que el presupuesto no limita el consumo, solo envía notificaciones.

Riesgo identificado:
- La alerta no detiene automáticamente los recursos.
- Si una VM queda encendida, puede seguir consumiendo crédito aunque exista alerta.

------------------------------------------------------------
3. Ingreso a Compute Engine
------------------------------------------------------------
Se ingresó a Compute Engine para preparar la creación de una máquina virtual.

Estado inicial:
- Total VMs: 0.
- Discos: 0.
- Snapshots: 0.
- Instance Groups: 0.
- Images: 0.

Resultado:
- Entorno limpio, sin recursos previos.

------------------------------------------------------------
4. Habilitación de Compute Engine API
------------------------------------------------------------
Al intentar crear la instancia, Google solicitó habilitar la API requerida.

API:
- Compute Engine API.

Acción:
- Se habilitó la API desde la ventana emergente de Google Cloud.

Resultado:
- Compute Engine quedó disponible para crear VMs.

------------------------------------------------------------
5. Configuración inicial de la VM
------------------------------------------------------------
Se inició la creación de una VM.

Configuración inicial:
- Nombre: arcgis-enterprise-lab.
- Región: us-central1 / Iowa.
- Zona: us-central1-a.
- Tipo de máquina: e2-standard-4.
- Recursos: 4 vCPU / 16 GB RAM.

Estimado inicial:
- Aproximadamente USD 97.84/mes solo por cómputo.

Resultado:
- Configuración base correcta para laboratorio.

------------------------------------------------------------
6. Revisión de sistema operativo Windows Server
------------------------------------------------------------
Se intentó seleccionar Windows Server para instalar ArcGIS Enterprise en Windows.

Sistema seleccionado inicialmente:
- Windows Server 2025 Datacenter.
- Disco: 200 GB.

Resultado:
- Google Cloud mostró advertencia:
  "VMs based on Windows Server images can't be created while in the Free Trial program."

Decisión:
- No hacer Upgrade a cuenta paga.
- Descartar Windows Server para mantener el laboratorio dentro del Free Trial.

------------------------------------------------------------
7. Evaluación de Red Hat Enterprise Linux
------------------------------------------------------------
Se cambió el sistema operativo a Red Hat Enterprise Linux 9.

Configuración:
- Sistema operativo: Red Hat Enterprise Linux 9.
- Disco: 200 GB.
- Máquina: e2-standard-4.

Costo estimado:
- USD 159.88/mes.
- Cargo adicional detectado:
  Premium image usage fee: USD 42.05.

Decisión:
- Descartar Red Hat para evitar costo premium adicional.

------------------------------------------------------------
8. Selección final de sistema operativo
------------------------------------------------------------
Se seleccionó Ubuntu como sistema operativo final para la VM.

Configuración final:
- Sistema operativo: Ubuntu 24.04 LTS Minimal.
- Licencia: Free.
- Disco: 200 GB balanced persistent disk.
- Máquina: e2-standard-4.
- Región: us-central1.
- Zona: us-central1-a.

Costo estimado:
- USD 117.84/mes.
- Aproximadamente USD 0.16/hora.

Resultado:
- Sistema operativo sin cargo premium.
- Configuración aceptada para continuar el laboratorio.

------------------------------------------------------------
9. Configuración de protección de datos
------------------------------------------------------------
Se revisó la sección Data Protection.

Configuración aplicada:
- Backups: No backups.
- Snapshot schedules: desactivado.
- Synchronous replication: desactivado.
- Asynchronous replication: desactivado.

Decisión:
- No activar backups automáticos para reducir costos durante el laboratorio.

Riesgo:
- Si se elimina o corrompe el disco, no habrá recuperación automática.
- Para laboratorio es aceptable.
- Para producción no sería aceptable.

------------------------------------------------------------
10. Configuración de red
------------------------------------------------------------
Se revisó la sección Networking.

Configuración:
- Firewall HTTP: habilitado.
- Firewall HTTPS: habilitado.
- Load Balancer Health Checks: deshabilitado.
- Network tags:
  - http-server.
  - https-server.
- Network interface: nic0 default.
- IP stack: IPv4 single-stack.
- External IPv4 address: Ephemeral.
- Internal IPv4 address: Ephemeral / Automatic.
- Network Service Tier: Premium.
- Public DNS PTR Record: deshabilitado.

Resultado:
- Red configurada para permitir tráfico web básico.
- IP externa asignada dinámicamente.

------------------------------------------------------------
11. Configuración de observabilidad
------------------------------------------------------------
Se revisó la sección Observability.

Configuración:
- Install Ops Agent: desmarcado.
- Enable display device: desmarcado.

Decisión:
- No instalar Ops Agent por ahora para mantener el laboratorio simple.
- El monitoreo puede activarse después si se requiere.

------------------------------------------------------------
12. Configuración de seguridad
------------------------------------------------------------
Se revisó la sección Security.

Configuración:
- Service account: Compute Engine default service account.
- Access scopes: Allow default access.
- Confidential VM: desactivado.
- Secure Boot: desmarcado.
- vTPM: activado.
- Integrity Monitoring: activado.
- SSH: gestionado automáticamente por consola de Google.

Resultado:
- Configuración aceptada para laboratorio.
- Acceso SSH disponible desde navegador.

------------------------------------------------------------
13. Creación de la VM
------------------------------------------------------------
Se creó la máquina virtual.

Resultado:
- Nombre: arcgis-enterprise-lab.
- Estado: Running.
- Zona: us-central1-a.
- IP interna: 10.128.0.2.
- IP externa: 136.115.251.171.
- Conexión: SSH disponible.

------------------------------------------------------------
14. Conexión SSH
------------------------------------------------------------
Se ingresó a la VM mediante SSH-in-browser de Google Cloud.

Resultado:
- Conexión exitosa.
- Usuario conectado: milo1409.
- Hostname: arcgis-enterprise-lab.
- Sistema detectado: Ubuntu 24.04.1/24.04.4 LTS.

------------------------------------------------------------
15. Validación de recursos de la VM
------------------------------------------------------------
Se ejecutaron comandos de validación:

Comandos:
- hostname.
- whoami.
- lsb_release -a.
- free -h.
- df -h.
- nproc.

Resultado:
- Hostname: arcgis-enterprise-lab.
- Usuario: milo1409.
- Sistema operativo: Ubuntu 24.04.4 LTS.
- RAM: 15 GiB disponibles aproximadamente.
- CPU: 4 vCPU.
- Disco raíz: 193 GB.
- Disco disponible inicial: aproximadamente 191–192 GB.
- Swap: 0.

Conclusión:
- La VM quedó apta para continuar con preparación base.

------------------------------------------------------------
16. Actualización inicial del sistema
------------------------------------------------------------
Se ejecutó:

sudo apt update

Resultado:
- Repositorios Ubuntu noble detectados correctamente.
- Paquetes actualizables: 11.

Luego se ejecutó:

sudo apt upgrade -y

Resultado:
- Paquetes actualizados correctamente.
- Se observaron advertencias normales de debconf por ser una imagen Ubuntu minimal.
- No se identificaron errores críticos.

Después se ejecutó:

sudo reboot

Resultado:
- Reinicio enviado correctamente.
- La VM reinició y se reconectó por SSH sin problemas.

------------------------------------------------------------
17. Validación posterior al reinicio
------------------------------------------------------------
Se ejecutaron comandos:

- hostname.
- uptime.
- free -h.
- df -h.

Resultado:
- Hostname: arcgis-enterprise-lab.
- Uptime posterior al reinicio: aproximadamente 1 minuto.
- RAM: 15 GiB.
- Disco raíz: 193 GB.
- Disco disponible: 191 GB.
- Actualizaciones pendientes: 0.

Conclusión:
- La VM quedó reiniciada, estable y sin actualizaciones pendientes.

------------------------------------------------------------
18. Instalación de utilidades básicas
------------------------------------------------------------
Se instalaron utilidades base con:

sudo apt install -y unzip zip tar gzip curl wget net-tools lsof tree nano vim acl chrony

Resultado:
- unzip, zip, tar, gzip instalados.
- curl y wget instalados.
- net-tools, lsof y tree instalados.
- nano y vim instalados.
- acl instalado.
- chrony instalado.
- Se observaron advertencias de update-alternatives relacionadas con páginas de manual de vim.
- No son errores críticos.

------------------------------------------------------------
19. Validación de tiempo y NTP
------------------------------------------------------------
Se ejecutó:

timedatectl

Estado inicial:
- Zona horaria: Etc/UTC.
- System clock synchronized: yes.
- NTP service: active.

Luego se cambió la zona horaria:

sudo timedatectl set-timezone America/Bogota

Validación posterior:
- Time zone: America/Bogota.
- Offset: -05.
- NTP service: active.
- System clock synchronized: yes.
- Hora local validada con date.

Resultado:
- La VM quedó configurada con hora Colombia.

------------------------------------------------------------
20. Punto de pausa
------------------------------------------------------------
Se pausó antes de ejecutar el Punto 16 propuesto originalmente:

Pendiente:
- Crear usuario del sistema operativo para ArcGIS:
  sudo useradd -m -s /bin/bash arcgis
  sudo passwd arcgis

Estado actual:
- VM creada.
- VM actualizada.
- VM reiniciada.
- SSH funcional.
- Zona horaria configurada.
- Utilidades básicas instaladas.
- Usuario arcgis aún no creado.
