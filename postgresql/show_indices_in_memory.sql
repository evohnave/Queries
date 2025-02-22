/*
Show which indices are in memory and how many buffers they are using
Ref: https://x.com/crunchydata/status/1892621662928920918
Hail to Craig Kerstiens
*/
SELECT   cl.relname AS index_name
       , COUNT(*) AS buffers
       , ROUND(COUNT(*) * CURRENT_SETTING('block_size')::INT / 1024.0, 2) AS buffer_size_kb
  FROM   pg_buffercache bc JOIN pg_class cl ON bc.relfilenode = pg_relation_filenode(cl.oid)
 WHERE   cl.relkind = 'i'
 GROUP   BY cl.relname
 ORDER   BY buffers DESC
;
