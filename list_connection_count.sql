-- For PostgreSQL

SELECT   datname "Database"
       , state
       , COUNT(*)
  FROM   pg_stat_activity
 WHERE   pid <> pg_backend_pid()
 GROUP   BY 2, 1
 ORDER   BY 2
;
