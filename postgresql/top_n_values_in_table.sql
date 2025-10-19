/*

This query can help you to understand the statistics of the values 
  in your table or even just a column of a table
Inspired from https://x.com/crunchydata/status/1979160222552805807

*/
WITH   ranked_values AS (
         SELECT   ps.starelid::regclass AS "Table"
                , pa.attname AS "Column"
                , v
                , n::numeric AS n_numeric
                , ROW_NUMBER() OVER (
                    PARTITION BY ps.starelid, pa.attname 
                    ORDER BY n::numeric DESC
                  ) AS rn
           FROM   pg_statistic ps
           JOIN   pg_attribute pa ON pa.attrelid = ps.starelid
                  AND pa.attnum = ps.staattnum
           JOIN   pg_class pc ON pa.attrelid = pc.oid 
           JOIN   pg_namespace pn ON pc.relnamespace = pn.oid
          CROSS   JOIN LATERAL UNNEST(
                     ps.stanumbers1::text[], ps.stavalues1::text::text[]
                  ) 
                  WITH ORDINALITY AS unnested(n, v, idx)
          WHERE   pn.nspname NOT LIKE 'pg%' 
                  AND pn.nspname <> 'information_schema'
-- You can add in further constraints here to limit the table or the column
--                AND pa.attname = 'Column_to_find'
-- etc
)
SELECT   "Table"
       , "Column"
       , STRING_AGG(FORMAT(E'\'%s\': %s%%\n', v, ROUND(n_numeric*100, 2)), '')
  FROM   ranked_values
-- Change the next line to limit the number of values returned.
--   It is currently 10
 WHERE   rn <= 10
 GROUP   BY "Table", "Column"
;
