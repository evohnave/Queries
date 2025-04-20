SELECT   usename AS "User"
       , state AS "Connection State"
       , count(1) AS "Number Of Connections"
  FROM   pg_stat_activity
 WHERE   usename IS NOT NULL
 GROUP   BY 1, 2
 ORDER   BY 1 ASC, 2 DESC
;
