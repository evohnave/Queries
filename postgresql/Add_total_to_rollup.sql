/*
The key is the WHEN GROUPING(field) = 1
*/

SELECT   CASE
           WHEN GROUPING(rc.descr) = 1 THEN 'Total'
           ELSE rc.descr
         END "Descr"
         , COUNT(*) 'Count'
  FROM   s_table s
  JOIN   rc_table rc
    ON   rc.rc_id = s.rc_id
 WHERE   s.enabled = 1
         AND other_criteria = 2
 GROUP   BY ROLLUP(rc.descr)
 ;
