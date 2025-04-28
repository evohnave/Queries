/*
This query will check that passwords (for roles that can log in) have been upgraded to use SCRAM Authentication.

Hail to Crunchy Data on X:  https://x.com/crunchydata/status/1916843926549364847

Also, check your parameter group for password_encryption as scram-sha-256

*/

SELECT   rolname
       , rolpassword ~ '^SCRAM-SHA-256\$' AS has_upgraded
  FROM   pg_authid
 WHERE   rolcanlogin
;

