/*
Source: Twitter: CrunchyData.com 2024-07-05T03:24:00
https://x.com/crunchydata/status/1809307419904004410

Postgres tip of the day: 
Find processes that have a wait event, rolling up to the PID holding the initial lock.

This query looks at at the pg_stat_activity and pg_locks view showing the pid, state, wait_event, and lock mode, as well as blocking pids.
*/

WITH   sos AS (
       SELECT   array_cat(array_agg(pid)
             ,  array_agg((pg_blocking_pids(pid))[array_length(pg_blocking_pids(pid), 1)])
                         ) pids
         FROM   pg_locks
        WHERE   NOT granted
)
SELECT   http://a.pid
      ,  a.usename
      ,  a.datname
      ,  a.state
      ,  a.wait_event_type || ': ' || a.wait_event AS wait_event
      ,  current_timestamp - a.state_change time_in_state
      ,  current_timestamp - a.xact_start time_in_xact
      ,  l.relation::regclass relname
      ,  l.locktype
      ,  l.mode
      ,  http://l.page
      ,  l.tuple
      ,  pg_blocking_pids(http://l.pid) blocking_pids
      ,  (pg_blocking_pids(http://l.pid))[array_length(pg_blocking_pids(http://l.pid), 1)] last_session
      ,  COALESCE((pg_blocking_pids(http://l.pid))[1] || '.' || coalesce(
             CASE 
                 WHEN locktype = 'transactionid' THEN 1 
                 ELSE array_length(pg_blocking_pids(http://l.pid),1) + 1
             END, 0
         )
      ,  http://a.pid || '.0') lock_depth
      ,  a.query
  FROM   pg_stat_activity a
  JOIN   sos s ON (http://a.pid = ANY(s.pids))
  LEFT   OUTER JOIN pg_locks l ON (http://a.pid = http://l.pid AND NOT l.granted)
 ORDER   BY lock_depth
;
