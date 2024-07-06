/*
This function determines the date of the start date plus a number of business
  days.  The number of business days must be positive (i.e., looking for a
  date in the future).

Usage:

SELECT   *
  FROM   ADD_BUSINESS_DAYS('2023-09-01'::DATE, 5)
;

*/
CREATE  OR REPLACE FUNCTION ADD_BUSINESS_DAYS(start_date DATE, num_days BIGINT)
        RETURNS DATE
        AS $ABD$
           SELECT  d::DATE
             FROM  GENERATE_SERIES(start_date,
                                   start_date + num_days * 2 * INTERVAL '1d',
                                   '1 day'::INTERVAL) d
            WHERE EXTRACT('dow' FROM d) NOT IN (0, 6)
            LIMIT 1
            OFFSET num_days
        $ABD$ LANGUAGE SQL
;
