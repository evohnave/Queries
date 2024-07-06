/* Get table names */
SELECT t.table_name
  FROM information_schema.tables t
 WHERE t.table_schema = 'public'  -- public | pg_catalog
       AND t.table_type = 'BASE TABLE'
 ORDER BY t.table_name;
