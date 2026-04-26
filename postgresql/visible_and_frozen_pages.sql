-- Get the Visible and Frozen pages  
-- Requires the extension pg_visibility  
-- CREATE EXTENSION IF NOT EXISTS pg_visibility;

SELECT   c.relpages AS "Total Pages"
       , s.all_visible AS "Visible"
       , s.all_frozen AS "Frozen"
       , ROUND(100.0 * s.all_visible/NULLIF(c.relpages, 0), 1) AS "Pct Visible"
       , ROUND(100.0 * s.all_frozen/NULLIF(c.relpages, 0), 1) AS "Pct Frozen"
  FROM   pg_class c
 CROSS   JOIN LATERAL pg_visibility_map_summary(c.oid) s
 WHERE   c.relname = "books"
;
