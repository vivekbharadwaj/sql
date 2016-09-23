DROP TABLE tester;
CREATE VOLATILE TABLE tester AS
(
    SELECT * FROM (select 'a' AS id, 1 as mycol) a
    UNION
    SELECT * FROM (select 'a' AS id, 2 as mycol) a
    UNION
    SELECT * FROM (select 'a' AS id, 3 as mycol) a
    UNION
    SELECT * FROM (select 'a' AS id, 4 as mycol) a
    UNION
    SELECT * FROM (select 'a' AS id, 5 as mycol) a
    UNION
    SELECT * FROM (select 'a' AS id, 6 as mycol) a
    UNION
    SELECT * FROM (select 'a' AS id, 7 as mycol) a
    UNION
    SELECT * FROM (select 'a' AS id, 8 as mycol) a
    UNION
    SELECT * FROM (select 'a' AS id, 9 as mycol) a

    UNION

    SELECT * FROM (select 'b' AS id, 11 as mycol) a
    UNION
    SELECT * FROM (select 'b' AS id, 12 as mycol) a
    UNION
    SELECT * FROM (select 'b' AS id, 13 as mycol) a
    UNION
    SELECT * FROM (select 'b' AS id, 14 as mycol) a
    UNION
    SELECT * FROM (select 'b' AS id, 15 as mycol) a
    UNION
    SELECT * FROM (select 'b' AS id, 16 as mycol) a
    UNION
    SELECT * FROM (select 'b' AS id, 17 as mycol) a
    UNION
    SELECT * FROM (select 'b' AS id, 18 as mycol) a
    UNION
    SELECT * FROM (select 'b' AS id, 19 as mycol) a

)
WITH DATA
PRIMARY INDEX (mycol)
ON COMMIT PRESERVE ROWS
;

--with lead it's simply "PRECEDING"
SELECT
    a.*
    ,MIN(mycol) OVER (ORDER BY mycol ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING)
FROM tester a
;
