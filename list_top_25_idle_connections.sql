SELECT   pid
       , usename
       , datname
       , appliction_name
       , AGE(NOW(), backend_start)
       , AGE(NOW(), state_change)
  FROM   pg_stat_activity
 WHERE   state='idle'
 ORDER   BY 6
 LIMIT   25
;
