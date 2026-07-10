-- Preparación de PostGIS para EGDB en Cloud SQL PostgreSQL.
-- Ejecutar conectado a la base egdb con usuario administrador Cloud SQL.
-- ADVERTENCIA: DROP EXTENSION CASCADE solo debe usarse antes de crear datos dependientes.

SELECT version();
SELECT current_database();
SELECT current_user;

SELECT name, default_version, installed_version
FROM pg_available_extensions
WHERE name LIKE 'postgis%'
ORDER BY name;

DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis VERSION '3.5.2';

SELECT postgis_full_version();
