-- Requires the pgstattuple extension
-- CREATE EXTENSION IF NOT EXISTS pgstattuple;

SELECT   relname AS "Table Name"
       , PG_SIZE_PRETTY(PG_RELATION_SIZE(relid)) AS "Table Size"
       , (pgstattuple(relid)).dead_tuple_percent AS "Pct Dead"
       , (pgstattuple(relid)).free_percent AS "Pct Free"
  FROM   pg_catalog.pg_stat_user_tables
 ORDER   BY "Pct Dead" DESC
;
