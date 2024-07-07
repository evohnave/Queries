/*
Hail to Craig Kerstiens
https://x.com/craigkerstiens/status/1620839720354971648
*/

/*
Install pg_stat_statements
*/
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

/*
Log slow queries
Define "slow" yourself
*/
ALTER DATABASE dbname SET log_min_duration_statment = '500ms';

/*
Set up auto_explain to log the explain plan for slow queries
There are extensions, but also see the docs
https://www.postgresql.org/docs/current/auto-explain.html
*/
LOAD 'auto_explain';
SET auto_explain.log_min_duration = '3s';
SET auto_explain.log_analyze = true;
-- run a query, look at the logs
-- turn off if desired
SET auto_explain.log_min_duration = -1;
SET auto_explain.log_analyze = false;

/*
Auto-kill long running queries
*/
ALTER DATABASE dbname SET statement_timeout = '30s';
