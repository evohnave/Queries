/*
This function determines the number of business days between a start_date and
  an end_date.  If the start and end dates are the same (or non-business days
  after a Friday) then there will be 0 business days between the two dates.

Usage

WITH   days AS (
       SELECT   d::date
         FROM   generate_series(to_date('2023-09-01', 'yyyy-mm-dd'),
                                to_date('2023-09-30', 'yyyy-mm-dd'),
                                '1 day'::interval) d
       )
SELECT   '2023-09-01'::date "FROM"
       , days.d "TO"
       , count_business_days('2023-09-01'::date, days.d) "Num B Days"
  FROM  days ORDER BY 2 ASC
;

*/

CREATE  OR REPLACE FUNCTION COUNT_BUSINESS_DAYS(start_date DATE, end_date DATE)
        RETURNS BIGINT
        AS $CBD$
           SELECT   COUNT(d::DATE) - 1 AS d
             FROM   GENERATE_SERIES(start_date, end_date, '1 day'::INTERVAL) d
            WHERE   EXTRACT('dow' FROM d) NOT IN (0, 6)
        $CBD$ LANGUAGE SQL
;
