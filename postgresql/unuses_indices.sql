/*
List unused indices
Hail to Craig Kerstiens
https://x.com/crunchydata/status/1882123319572324691
*/
SELECT   schemaname || '.' || relname AS table
       , indexrelname AS index
       , PG_SIZE_PRETTY(PG_RELATION_SIZE(i.indexrelid)) AS "index size"
       , idx_scan as "index scans"
  FROM   pg_stat_user_indexes ui
  JOIN   pg_index i ON ui.indexrelid = i.indexrelid
 WHERE   NOT indisunique
         AND idx_scan < 50
         AND PG_RELATION_SIZE(relid) > 5 * 8192
 ORDER   BY PG_RELATION_SIZE(i.indexrelid) / NULLIF(idx_scan, 0) DESC NULLS FIRST
       , PG_RELATION_SIZE(i.indexrelid) DESC
;
