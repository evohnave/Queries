/*
Show which tables are in memory and how many buffers they are using
Ref: https://x.com/crunchydata/status/1892621662928920918
Hail to Craig Kerstiens
*/
SELECT   c.relname AS table_name
       , COUNT(*) AS buffers
       , ROUND(COUNT(*) * CURRENT_SETTING('block_size')::INT / 1024.0, 2) AS buffer_size_kb
  FROM   pg_buffercache bc
  JOIN   pg_class cl ON bc.relfilenode = pg_relation_filenode(cl.oid)
  JOIN   pg_namespace ns ON ns.oid = cl.relnamespace -- Join to get schema name
 WHERE   cl.relkind = 'r' -- 'r' = regular table
         AND ns.nspname NOT IN ('pg_catalog', 'information_schema') -- Exclude internal schemas
 GROUP   BY cl.relname
 ORDER   BY buffers DESC
;
