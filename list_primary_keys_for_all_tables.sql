SELECT   tc.constraint_type CONSTRAINT
       , tc.table_schema SCHEMA
       , tc.table_name TABLE
       , string_agg(kc.column_name, ', ') CONSTRAINT
  FROM   information_schema.table_constraints tc
  JOIN   information_schema.key_column_usage kc
    ON   kc.table_name = tc.table_name
   AND   kc.table_schema = tc.table_schema
   AND   kc.constraint_name = tc.constraint_name
 WHERE   kc.ordinal_position IS NOT NULL
   AND   tc.constraint_type = 'PRIMARY KEY'
 GROUP   BY 1, 2, 3
 ORDER   BY 2, 3
;