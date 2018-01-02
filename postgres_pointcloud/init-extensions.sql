CREATE EXTENSION "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_sfcgal;
CREATE EXTENSION IF NOT EXISTS pointcloud;
CREATE EXTENSION IF NOT EXISTS pointcloud_postgis;

CREATE OR REPLACE FUNCTION public.st_triangulate2dz(geometry)
  RETURNS geometry AS
'$libdir/postgis-2.3', 'sfcgal_triangulate'
  LANGUAGE c IMMUTABLE STRICT
  COST 100;

