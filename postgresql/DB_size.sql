/* PostgreSQL Functions */

SELECT pg_size_pretty(pg_database_size('<dbname here>'));

/* PostgreSQL Disk Usage... taken from the Postgres wiki */
SELECT *, pg_size_pretty(total_bytes) AS total
    , pg_size_pretty(index_bytes) AS INDEX
    , pg_size_pretty(toast_bytes) AS toast
    , pg_size_pretty(table_bytes) AS TABLE
  FROM (
  SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes FROM (
      SELECT c.oid,nspname AS table_schema, relname AS TABLE_NAME
              , c.reltuples AS row_estimate
              , pg_total_relation_size(c.oid) AS total_bytes
              , pg_indexes_size(c.oid) AS index_bytes
              , pg_total_relation_size(reltoastrelid) AS toast_bytes
          FROM pg_class c
          LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
          WHERE relkind = 'r'
  ) a
) a;

/* My version of the above, looking only at the Public tables */
SELECT *, pg_size_pretty(total_bytes) AS "Total", 
       pg_size_pretty(index_bytes) AS "Index", 
       pg_size_pretty(toast_bytes) AS "Toast", 
       pg_size_pretty(table_bytes) AS "Table"
  FROM (
        SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes 
          FROM (
                SELECT c.oid,nspname AS table_schema, relname AS "Table_Name", 
                       c.reltuples AS "Row_Estimate", pg_total_relation_size(c.oid) AS total_bytes, 
                       pg_indexes_size(c.oid) AS index_bytes, 
                       pg_total_relation_size(reltoastrelid) AS toast_bytes
                  FROM pg_class AS c
                       LEFT JOIN pg_namespace AS n ON n.oid = c.relnamespace
                 WHERE relkind = 'r'
                       AND nspname = 'public' -- delete line if you want to include pg_ System Tables
               ) AS a
        ) a
  ORDER BY total_bytes DESC;

