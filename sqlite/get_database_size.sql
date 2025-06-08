/*
See https://www.sqlite.org/pragma.html#pragma_page_count
  pragma_page_count() returns thenumber of pages
  pragma_page_size() returns the page size
    The product of these two is the size of the database
  PRAGMA schema.page_size = <bytes>; <- sets the size of the page
*/

SELECT page_count * page_size as size FROM pragma_page_count(), pragma_page_size();
