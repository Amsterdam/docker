CREATE EXTENSION "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;
DO $$
BEGIN
   IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_roles
      WHERE  rolname = 'postgres') THEN
      CREATE USER postgres WITH SUPERUSER;
   END IF;
END $$;
