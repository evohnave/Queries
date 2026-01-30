/*
This quick query will show if you're doing too many sequential scans.
You may want to add an index if you are.
*/

SELECT    relname
        , seq_scan
        , seq_tup_read
        , idx_scan
  FROM    pg_stat_user_tables
 WHERE    seq_scan > 0
 ORDER    BY seq_tup_read DESC
 LIMIT    10
;

