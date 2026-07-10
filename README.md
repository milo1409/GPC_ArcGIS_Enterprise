# Proyecto VANTI — ArcGIS Enterprise 11.5 en Google Cloud + Cloud SQL PostgreSQL + Utility Network

## 1. Resumen ejecutivo

Este proyecto valida una arquitectura de laboratorio para desplegar **ArcGIS Enterprise 11.5 en Google Cloud Platform (GCP)** y utilizar **Google Cloud SQL for PostgreSQL** como repositorio de **Enterprise Geodatabase (EGDB)** con **PostGIS** y **Utility Network**.

El objetivo principal fue demostrar si una geodatabase corporativa alojada en Cloud SQL PostgreSQL puede soportar operaciones reales de ArcGIS Enterprise y Utility Network, incluyendo:

- Habilitación de Enterprise Geodatabase.
- Creación de usuario administrador `sde` y usuario propietario de datos `dataowner`.
- Creación de Utility Network.
- Aplicación de Asset Package.
- Publicación de servicio referenciado en ArcGIS Enterprise.
- Ejecución de trazas de Utility Network.
- Edición de entidades.
- Validación de topología.
- Verificación directa en PostgreSQL mediante pgAdmin.

La validación fue exitosa. La arquitectura demostró que Cloud SQL PostgreSQL puede alojar una EGDB funcional con tablas SDE y componentes internos de Utility Network, siempre que se respeten las versiones compatibles de PostgreSQL/PostGIS y se controlen adecuadamente la red, permisos, latencia y recursos.

---

## 2. Arquitectura validada

### 2.1 Componentes principales

| Componente | Tecnología / Servicio | Rol dentro de la arquitectura |
|---|---|---|
| ArcGIS Enterprise | ArcGIS Enterprise 11.5 sobre VM Linux en GCP | Plataforma GIS corporativa: Portal, Server, Data Store y Web Adaptor |
| Portal for ArcGIS | Instalado en VM Linux | Portal de contenidos, usuarios, federación y publicación |
| ArcGIS Server | Instalado en VM Linux | Hosting Server, publicación de servicios y ejecución de operaciones GIS |
| ArcGIS Data Store | Instalado en VM Linux | Data Store relacional del portal para contenido alojado |
| Web Adaptor Java | Tomcat 10 sobre VM Linux | Publicación de endpoints `/portal` y `/server` |
| Cloud SQL PostgreSQL | PostgreSQL 15.18 | Motor relacional para la Enterprise Geodatabase |
| PostGIS | 3.5.2 | Tipo espacial usado por ArcGIS para Cloud SQL PostgreSQL |
| Enterprise Geodatabase | Esquema `sde` en Cloud SQL | Catálogo geodatabase, versionamiento, metadatos y tablas de sistema |
| Utility Network | Modelo Gas / Pipeline | Red de servicios validada con trazas, edición y topología |
| ArcGIS Pro | VM Windows temporal en GCP | Carga de Asset Package, publicación, edición y validaciones |
| pgAdmin | VM Windows / cliente | Inspección directa de tablas SDE y Utility Network |

### 2.2 Diagrama lógico

```text
Usuario / Administrador
        |
        | RDP / Navegador / ArcGIS Pro
        v
+--------------------------------------------------+
| Google Cloud Platform                            |
|                                                  |
|  +-------------------------------+               |
|  | VM Linux ArcGIS Enterprise    |               |
|  | - Portal for ArcGIS           |               |
|  | - ArcGIS Server               |               |
|  | - ArcGIS Data Store           |               |
|  | - Tomcat + Web Adaptor        |               |
|  +---------------+---------------+               |
|                  |                               |
|                  | IP privada / VPC              |
|                  v                               |
|  +-------------------------------+               |
|  | Cloud SQL PostgreSQL          |               |
|  | - Base egdb                   |               |
|  | - Esquema sde                 |               |
|  | - Esquema dataowner           |               |
|  | - PostGIS 3.5.2               |               |
|  | - Tablas SDE y UN             |               |
|  +-------------------------------+               |
|                                                  |
|  +-------------------------------+               |
|  | VM Windows ArcGIS Pro Loader  |               |
|  | - ArcGIS Pro                  |               |
|  | - Asset Package               |               |
|  | - pgAdmin                     |               |
|  +-------------------------------+               |
+--------------------------------------------------+
```

---

## 3. Alcance validado

El laboratorio validó los siguientes puntos:

1. Creación de infraestructura base en GCP.
2. Preparación de VM Linux para ArcGIS Enterprise.
3. Instalación de Portal for ArcGIS, ArcGIS Server, ArcGIS Data Store y Web Adaptor.
4. Federación de ArcGIS Server con Portal.
5. Configuración del Hosting Server.
6. Creación de Cloud SQL PostgreSQL.
7. Ajuste de PostGIS a versión compatible.
8. Habilitación de Enterprise Geodatabase.
9. Creación de usuarios `sde` y `dataowner`.
10. Creación inicial de Utility Network con Stage Utility Network.
11. Aplicación de Asset Package desde VM Windows en GCP.
12. Registro de EGDB como Data Store en ArcGIS Server.
13. Publicación del servicio `Gas_Utility_Network`.
14. Ejecución de Trace tipo Subnetwork.
15. Edición de entidad tipo Pipeline Junction.
16. Validación de topología.
17. Verificación en pgAdmin de tablas SDE y tablas internas de Utility Network.

---

## 4. Resultados principales

| Prueba | Resultado | Observación |
|---|---:|---|
| Instalación ArcGIS Enterprise 11.5 | Exitosa | VM Linux en GCP |
| Web Adaptor Portal / Server | Exitoso | Tomcat 10, endpoints `/portal` y `/server` |
| Federación ArcGIS Server | Exitosa | Server configurado como Hosting Server |
| Cloud SQL PostgreSQL | Exitoso | PostgreSQL 15.18 |
| PostGIS compatible | Exitoso | Requiere 3.5.2; evitar 3.6.0 |
| Enable Enterprise Geodatabase | Exitoso | Ejecutado con usuario `sde` |
| Create Database User | Exitoso | Usuario `dataowner` creado desde ArcGIS Pro |
| Stage Utility Network | Exitoso | Dataset `ungas` creado |
| Apply Asset Package | Exitoso | Ejecutado desde VM Windows GCP, 27 minutos aprox. |
| Registro de Data Store | Exitoso | Data Store validado contra Hosting Server |
| Publicación de servicio | Exitosa | Map Image Layer creado en Portal |
| Trace Utility Network | Exitoso | Subnetwork trace finalizó correctamente |
| Edición de entidades | Exitosa | Move/Rotate/Scale sobre Pipeline Junction |
| Validate Network Topology | Exitoso | Validación posterior a edición |
| Verificación pgAdmin | Exitosa | Tablas SDE y UN presentes |

---

## 5. Decisiones técnicas relevantes

### 5.1 Uso de Cloud SQL PostgreSQL como EGDB

Se validó que Cloud SQL PostgreSQL puede alojar una Enterprise Geodatabase funcional para ArcGIS Enterprise 11.5, usando PostGIS como tipo espacial.

Puntos clave:

- La base debe tener PostGIS en versión compatible.
- En este laboratorio se utilizó PostgreSQL 15.18.
- Se creó la base `egdb`.
- Se habilitó la geodatabase con usuario `sde`.
- Se creó un usuario propietario de datos `dataowner`.

### 5.2 Ajuste de PostGIS

Cloud SQL ofrecía una versión de PostGIS no adecuada para el escenario validado. Se corrigió recreando explícitamente la extensión PostGIS en versión 3.5.2.

Procedimiento usado en laboratorio:

```sql
DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis VERSION '3.5.2';
SELECT postgis_full_version();
```

> Advertencia: `DROP EXTENSION ... CASCADE` puede eliminar objetos dependientes. En producción debe ejecutarse únicamente antes de crear la EGDB o con un plan de respaldo y análisis de dependencias.

### 5.3 Uso de VM Windows temporal para ArcGIS Pro

Inicialmente la carga del Asset Package desde ArcGIS Pro local hacia Cloud SQL mediante IP pública fue muy lenta. La causa probable fue la latencia y la cantidad de operaciones transaccionales pequeñas ejecutadas por las herramientas de Utility Network.

Se resolvió desplegando una VM Windows temporal dentro de GCP, instalando ArcGIS Pro y conectando a Cloud SQL por IP privada.

Ruta inicial no eficiente:

```text
ArcGIS Pro local -> Internet -> Cloud SQL Public IP
```

Ruta validada:

```text
ArcGIS Pro en VM Windows GCP -> VPC -> Cloud SQL Private IP
```

---

## 6. Procedimiento resumido de implementación

### 6.1 Infraestructura GCP

1. Crear proyecto GCP.
2. Crear VM Linux para ArcGIS Enterprise.
3. Reservar o fijar IP pública para la VM Linux.
4. Configurar reglas de firewall:
   - 22 SSH.
   - 80/443 Web Adaptor.
   - 6080/6443 ArcGIS Server.
   - 7080/7443 Portal.
   - 9876 Data Store.
5. Crear Cloud SQL PostgreSQL con IP privada.
6. Crear VM Windows temporal para ArcGIS Pro.
7. Restringir RDP a IP administrativa.

### 6.2 Preparación Linux

1. Crear usuario `arcgis`.
2. Crear directorios `/arcgis`, `/arcgis/install`, `/arcgis/datastore`, `/arcgis/portal-content`.
3. Ajustar propietarios y permisos.
4. Configurar límites de sistema para usuario `arcgis`.
5. Configurar hostname y archivo `/etc/hosts`.
6. Instalar dependencias de Linux.

### 6.3 Instalación ArcGIS Enterprise

1. Copiar instaladores desde bucket GCS.
2. Extraer instaladores.
3. Instalar ArcGIS Server.
4. Autorizar ArcGIS Server con archivo `.ecp`.
5. Crear site de ArcGIS Server.
6. Instalar Portal for ArcGIS.
7. Crear Portal.
8. Instalar ArcGIS Data Store.
9. Configurar Data Store relacional.
10. Instalar Tomcat y Web Adaptor Java.
11. Registrar Web Adaptor para Server y Portal.
12. Federar Server con Portal.
13. Configurar Hosting Server.

### 6.4 Configuración Cloud SQL / EGDB

1. Crear base `egdb`.
2. Conectarse a PostgreSQL.
3. Instalar PostGIS 3.5.2.
4. Crear rol `sde`.
5. Crear esquema `sde`.
6. Asignar owner de base `egdb` a `sde`.
7. Ejecutar Enable Enterprise Geodatabase desde ArcGIS Pro.
8. Crear usuario `dataowner` con Create Database User.

### 6.5 Utility Network

1. Crear conexión `.sde` con `dataowner`.
2. Ejecutar Stage Utility Network.
3. Copiar Asset Package a VM Windows en GCP.
4. Ejecutar Apply Asset Package.
5. Validar datasets y tablas en ArcGIS Pro.
6. Registrar EGDB en ArcGIS Server como Data Store.
7. Publicar servicio `Gas_Utility_Network`.
8. Ejecutar Trace.
9. Probar edición.
10. Validar topología.
11. Verificar tablas en pgAdmin.

---

## 7. Validaciones realizadas

### 7.1 Validación de EGDB

Consulta sugerida:

```sql
SELECT *
FROM sde.sde_version
ORDER BY major ASC;
```

Resultado esperado:

```text
major = 11
minor = 5
bugfix = 0
```

### 7.2 Validación de tablas Utility Network

Ejemplos de tablas esperadas:

```text
pipelinedevice
pipelineedgeobject
pipelinejunction
pipelinejunctionobject
pipelineline
pipelinesubnetline
serviceterritory
structureboundary
structureedgeobject
structurejunction
structurejunctionobject
structureline
un_11_associations
un_11_dirtyareas
un_11_edges
un_11_junctions
un_11_rules
un_11_subnetworks
un_11_topology
un_11_traceconfigurations
```

### 7.3 Validación de operación funcional

Se validaron operaciones reales:

- Publicación de Map Image Layer.
- Trace tipo Subnetwork.
- Edición de entidades.
- Validación de topología.

---

## 8. Recomendaciones para producción

### 8.1 Infraestructura

- Usar un dominio DNS real, no nombres internos ni archivo `hosts`.
- Usar certificados TLS válidos emitidos por una CA confiable.
- Separar ambientes: desarrollo, pruebas y producción.
- Implementar alta disponibilidad de Portal, Server y Data Store si el RTO/RPO lo exige.
- Evaluar Cloud SQL HA regional para producción.
- Dimensionar Cloud SQL con CPU, RAM e IOPS suficientes para Utility Network.
- Evitar instancias mínimas para cargas, trazas y edición concurrente.

### 8.2 Red y seguridad

- Mantener Cloud SQL con IP privada siempre que sea posible.
- Evitar exposición permanente de IP pública de Cloud SQL.
- Restringir RDP/SSH a IPs administrativas.
- Usar cuentas de servicio con mínimos privilegios.
- Rotar credenciales usadas durante el laboratorio.
- Deshabilitar o eliminar VM Windows temporal cuando termine la carga.

### 8.3 ArcGIS Enterprise

- No usar usuarios administrativos (`sde`, `siteadmin`, `portaladmin`) para operación diaria.
- Crear usuarios propietarios de datos por dominio o aplicación.
- Registrar Data Stores con conexiones controladas.
- Usar `Unique numeric IDs` antes de publicar servicios formales.
- Validar capabilities requeridas para Utility Network antes de pasar a producción.
- Documentar extensiones, licencias y versiones exactas.

### 8.4 Base de datos

- Validar compatibilidad exacta de PostgreSQL/PostGIS antes de crear la EGDB.
- No actualizar automáticamente PostGIS sin validación previa con matriz Esri.
- Monitorear conexiones, locks, I/O, CPU y memoria.
- Crear respaldos antes de aplicar Asset Packages o cambios estructurales.
- Definir estrategia de vacuum/analyze para tablas grandes.
- Validar rendimiento de trazas con datos reales y concurrencia.

### 8.5 Utility Network

- Probar cargas con subconjuntos antes de cargar el modelo completo.
- Ejecutar Apply Asset Package desde una máquina cercana a la base de datos.
- Validar topología después de cargas y ediciones masivas.
- Monitorear dirty areas.
- Documentar reglas, tiers, subnetworks y configuraciones de traza.

---

## 9. Advertencias y riesgos

### 9.1 Compatibilidad PostGIS

El punto más crítico es la versión de PostGIS. Cloud SQL puede ofrecer versiones más recientes por defecto que no necesariamente son compatibles con ArcGIS Enterprise 11.5.

**Riesgo:** actualización automática o recreación de extensión a una versión no soportada.

**Mitigación:** bloquear procedimiento operativo, documentar versión validada y revisar matriz Esri antes de actualizar.

### 9.2 Latencia

La carga desde ArcGIS Pro local hacia Cloud SQL por IP pública fue lenta. Las herramientas de Utility Network hacen muchas operaciones pequeñas y transaccionales, por lo que la latencia impacta fuertemente.

**Mitigación:** ejecutar cargas pesadas desde VM dentro de GCP y usar IP privada.

### 9.3 Costos

La VM Windows y Cloud SQL generan costos. Las imágenes Windows tienen costo adicional de licencia.

**Mitigación:** apagar o eliminar la VM Windows cuando no se use. Ajustar Cloud SQL al tamaño requerido después de cargas.

### 9.4 Seguridad de credenciales

Durante el laboratorio se usaron credenciales visibles y simples.

**Mitigación:** rotar contraseñas antes de entregar o exponer el ambiente.

### 9.5 Certificados y nombres DNS

El laboratorio usó nombres internos y certificados no productivos.

**Mitigación:** usar DNS real y certificados válidos en producción.

### 9.6 Tomcat como root

En laboratorio se utilizó un ajuste no recomendado para permitir la configuración del Web Adaptor.

**Mitigación:** en producción, corregir permisos y ejecutar Tomcat con usuario de servicio no privilegiado.

---

## 10. Checklist para producción

- [ ] DNS público/privado definido.
- [ ] Certificados TLS válidos instalados.
- [ ] Cloud SQL con IP privada.
- [ ] Cloud SQL dimensionado para carga y operación.
- [ ] PostGIS en versión compatible.
- [ ] EGDB habilitada con usuario `sde`.
- [ ] Usuarios propietarios de datos creados.
- [ ] Data Store registrado en ArcGIS Server.
- [ ] Servicios publicados con IDs únicos.
- [ ] Utility Network con trazas validadas.
- [ ] Edición y validate topology probados.
- [ ] Backups configurados.
- [ ] Monitoreo habilitado.
- [ ] Credenciales rotadas.
- [ ] VM Windows temporal apagada/eliminada.
- [ ] Documentación técnica entregada.

---

## 11. Estructura del paquete de automatización

Este repositorio incluye archivos base para automatizar parcialmente el despliegue en GCP.

```text
vanti_arcgis_gcp_automation/
├── README.md
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── scripts/
│   ├── 01_linux_prepare.sh
│   ├── 02_upload_installers_from_gcs.sh
│   ├── 03_prepare_cloudsql_postgis.sql
│   ├── 04_prepare_sde_role.sql
│   ├── 05_validate_egdb.sql
│   └── 06_windows_loader_notes.ps1
└── docs/
    └── IMPLEMENTACION.md
```

> Nota: la instalación de ArcGIS Enterprise no se automatiza completamente porque requiere instaladores y licencias de Esri. Los scripts preparan infraestructura, sistema operativo, rutas y SQL base, pero la instalación final debe ejecutarse con los medios oficiales del cliente.

---

## 12. Conclusión general

El laboratorio demostró la viabilidad técnica de ejecutar ArcGIS Enterprise 11.5 en Google Cloud Platform y usar Google Cloud SQL PostgreSQL como Enterprise Geodatabase para Utility Network.

La prueba fue más allá de una conexión básica: se creó la EGDB, se cargó un modelo de Utility Network, se aplicó un Asset Package, se publicó un servicio, se ejecutaron trazas, se editaron entidades y se validó la topología. Además, se confirmó en PostgreSQL la existencia de tablas SDE y componentes internos de Utility Network.

La principal lección técnica fue que la cercanía entre ArcGIS Pro y Cloud SQL es crítica para cargas pesadas. La ejecución desde una VM Windows dentro de GCP permitió completar el proceso de forma exitosa, mientras que la carga desde una estación local por IP pública presentó lentitud significativa.

