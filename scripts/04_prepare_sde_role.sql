-- Preparación del rol sde para habilitar Enterprise Geodatabase.
-- Reemplazar password antes de ejecutar.
-- Ejecutar conectado a la base egdb con usuario administrador Cloud SQL.

CREATE ROLE sde
  WITH LOGIN
  PASSWORD 'CAMBIAR_PASSWORD_SDE'
  NOSUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE;

-- Reemplazar el nombre del usuario administrador si es diferente.
GRANT sde TO "arcgis-egdb-pg";

CREATE SCHEMA IF NOT EXISTS sde AUTHORIZATION sde;

GRANT CONNECT ON DATABASE egdb TO sde;
GRANT USAGE ON SCHEMA public TO sde;
GRANT USAGE, CREATE ON SCHEMA sde TO sde;
ALTER SCHEMA sde OWNER TO sde;
ALTER DATABASE egdb OWNER TO sde;

SELECT rolname, rolcanlogin, rolcreatedb, rolcreaterole, rolsuper
FROM pg_roles
WHERE rolname IN ('sde', 'arcgis-egdb-pg');

SELECT schema_name, schema_owner
FROM information_schema.schemata
WHERE schema_name = 'sde';

SELECT datname, pg_catalog.pg_get_userbyid(datdba) AS owner
FROM pg_database
WHERE datname = 'egdb';
