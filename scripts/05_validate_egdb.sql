-- Validaciones posteriores a Enable Enterprise Geodatabase y Utility Network.

SELECT extname, extversion
FROM pg_extension
WHERE extname = 'postgis';

SELECT *
FROM sde.sde_version
ORDER BY major ASC;

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema IN ('sde', 'dataowner')
ORDER BY table_schema, table_name;

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name LIKE 'un\_%' ESCAPE '\'
ORDER BY table_schema, table_name;
