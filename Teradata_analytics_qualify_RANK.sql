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

SELECT * FROM tester
QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY mycol DESC) <= 2
;