/*
Hail to Jesse Soyland's article "One PID To Lock Them All: Finding The Source
  of the Lock in Postgres" on crunchydata.com
*/


WITH sos AS (
  SELECT   ARRAY_CAT(ARRAY_AGG(pid)
         , ARRAY_AGG((pg_blocking_pids(pid))[ARRAY_LENGTH(pg_blocking_pids(pid), 1)])) pids
    FROM   pg_locks
   WHERE   NOT granted
)
SELECT   a.pid
       , a.usename
       , a.datname
       , a.state
       , a.wait_event_type || ': ' || a.wait_event AS wait_event
       , CURRENT_TIMESTAMP - a.state_change time_in_state
       , CURRENT_TIMESTAMP - a.xact_start time_in_xact
       , l.relation::regclass relname
       , l.locktype
       , l.mode
       , l.page
       , l.tuple
       , pg_blocking_pids(l.pid) blocking_pids
       , (pg_blocking_pids(l.pid))[ARRAY_LENGTH(pg_blocking_pids(l.pid), 1)] last_session
       , COALESCE((pg_blocking_pids(l.pid))[1] || '.' || COALESCE(
           CASE
             WHEN locktype='transactionid' THEN 1
             ELSE ARRAY_LENGTH(pg_blocking_pids(l.pid), 1) + 1
           END, 0)
       , a.pid||'.0') lock_depth
       , a.query
  FROM   pg_stat_activity a
  JOIN   sos s ON (a.pid = ANY(s.pids))
  LEFT   OUTER JOIN pg_locks l ON (a.pid = l.pid AND NOT l.granted)
 ORDER   BY lock_depth
;