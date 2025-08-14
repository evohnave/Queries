/*
Alter as necessary.  

Will create the extension pgstattuple if it does not exist.  

*/

CREATE EXTENSION IF NOT EXISTS pgstattuple;

SELECT   pc.relname AS index_name
       , tree_level
       , deleted_pages
       , avg_leaf_density
       , (100 - avg_leaf_density) AS bloat
       , leaf_fragmentation
  FROM   pg_class pc
  JOIN   pg_index ON pc.oid = pg_index.indexrelid
  JOIN   pg_namespace ns ON pc.relnamespace = ns.oid
 CROSS   JOIN LATERAL pgstatindex(pc.relname)
 WHERE   ns.nspname = 'public'
;
