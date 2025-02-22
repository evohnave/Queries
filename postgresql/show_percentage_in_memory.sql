/*
Show the percentages of tables in or out of memory
Ref: https://x.com/crunchydata/status/1892621662928920918
Hail to Craig Kerstiens
*/
WITH table_sizes AS (
     SELECT   c.oid
            , nspname AS schema_name
            , c.relname AS table_name
            , pg_table_size (c.oid) AS table_size_bytes
            , pg_relation_size(c.oid) AS relation_size_bytes
       FROM   pg_class c
       JOIN   pg_namespace n ON n.oid = c.relnamespace
      WHERE   c.relkind = 'r'
              AND nspname NOT IN ('pg_catalog', 'information_schema')
     ),
     cached_blocks AS (
     SELECT   c.oid
            , COUNT(*) AS cached_blocks
       FROM   pg_buffercache b
       JOIN   pg_class c ON b.relfilenode = pg_relation_filenode(c.oid)
      WHERE   c.relkind = 'r'
      GROUP   BY c.oid
     ),
     block_size AS (
     SELECT   current_setting('block_size')::INT AS block_size
     )
SELECT   ts.schema_name
       , ts.table_name
       , ts.table_size_bytes
       , COALESCE(cb.cached_blocks, 0) AS cached_blocks
       , ROUND(COALESCE(cb.cached_blocks, 0) * bs.block_size * 100.0 / NULLIF(ts.table_size_bytes, 0), 2) AS percent_in_cache
       , ROUND(100.0 - COALESCE(cb.cached_blocks, 0) * bs.block_size * 100.0 / NULLIF(ts.table_size_bytes, 0), 2) AS percent_not_in_cache
  FROM   table_sizes ts
  LEFT   JOIN cached_blocks cb ON ts.oid = cb.oid
 CROSS   JOIN block_size bs
 ORDER   BY percent_in_cache DESC
;
