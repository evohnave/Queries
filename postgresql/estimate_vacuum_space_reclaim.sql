/*
StackOverflow # 279232
Answer by Laurenz Albe

Is an expensive query

Requires extension pgstattuple
*/

SELECT   t.oid::regclass AS table_name
       , s.table_len AS size
       , dead_tuple_len + s.approx_free_space AS reclaimable
  FROM   pg_class AS t
 CROSS   JOIN LATERAL pgstattuple_approx(t.oid) AS s
 WHERE   t.relkind = 'r'
 ORDER   BY (s.dead_tuple_len::float8 + s.approx_free_space::float8)
          / (s.table_len::float8 + 1.0) DESC
;
