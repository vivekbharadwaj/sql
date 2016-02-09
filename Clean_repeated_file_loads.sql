USE [EXAMPLE_DATABASE]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SITUATION
--Raw data from 'n' different files have been loaded into the database multiple number of times. Need to come up with a way to eliminate the repeats and prepare a clean working dataset. The database has a primary key, and each dataset has a consolidated unique identifier such as stock name or file path etc.

--COMPLICATION
--1) The unique identifier between different files is not contiguous. Example, we can't simply say filter for records < 50,000. Some files might have gotten loaded twice or thrice before another file was loaded for the first time.
--2) Different files are loaded different number of times. 

--QUESTION
--Can I eliminate the repeats and get a clean dataset? 

--APPROACH
-- My solution is to pick the boundary values of the dtt_ids of the earliest instance of each stockname and then filter.

--Creating a mock dataset
IF object_id ('tempdb..#tbl') IS NOT NULL
	DROP TABLE #tbl

CREATE TABLE --drop table 
	#tbl (id INT, stockname VARCHAR(5), data VARCHAR(50));
INSERT INTO #tbl VALUES
	(1,'AAPL','asdrfsdfgsdfsdghrege'),(2,'AAPL','aegerfrvsfvahtjndzhdfgzfdgzdfbzedmtnd'),(3,'AAPL','asdghergrefAEdf'),
	(5,'GOOGL','bjjcunvcb  sdfgsd'),(6,'GOOGL',' gxbxt3434t3fd'),(7,'GOOGL',' dztrz vdvdrv'),

	(74,'AAPL','asdrfsdfgsdfsdghrege'),(75,'AAPL','aegerfrvsfvahtjndzhdfgzfdgzdfbzedmtnd'),(76,'AAPL','asdghergrefAEdf'),
	(77,'GOOGL','bjjcunvcb  sdfgsd'),(78,'GOOGL','gxbxt3434t3fd'),(79,'GOOGL',' dztrz vdvdrv'),
	(80,'YAHOO','nbmxbnxbzbvdfbdrt'),(81,'YAHOO','ytdjkyhsxbf'),

	(100,'AAPL','asdrfsdfgsdfsdghrege'),(101,'AAPL','aegerfrvsfvahtjndzhdfgzfdgzdfbzedmtnd'),(102,'AAPL','asdghergrefAEdf'),
	(103,'GOOGL','bjjcunvcb  sdfgsd'),(104,'GOOGL','gxbxt3434t3fd'),(105,'GOOGL',' dztrz vdvdrv'),
	(106,'YAHOO','nbmxbnxbzbvdfbdrt'),(107,'YAHOO','ytdjkyhsxbf');

SELECT * FROM #tbl


;WITH cte AS(
       SELECT a.stockname, MIN(a.id) AS row_to_start,  MIN(CASE WHEN b.diff_lead > 1 THEN b.xRow ELSE NULL END) AS number_of_rows
       FROM #tbl a INNER JOIN (SELECT stockname, id,
                                      (LEAD(id,1,NULL) OVER (PARTITION BY stockname ORDER BY id)) - id AS diff_lead,
                                      ROW_NUMBER() OVER(PARTITION BY stockname ORDER BY id) AS xRow FROM #tbl) b
              ON a.id = b.id
       GROUP BY a.stockname)
SELECT c.* FROM #tbl c
INNER JOIN cte
ON c.stockname = cte.stockname and
c.id >= cte.row_to_start and
c.id <= cte.row_to_start + cte.number_of_rows
ORDER BY 1

--HOW DOES THIS WORK?

--First, create an ordered list looping over stockname. 
--Then, find the leading id and get the difference. The primary key id is generated serially, so all records from the same load should have a difference in id of 1.

SELECT stockname, id
		,lead(id,1,null) OVER (PARTITION BY stockname ORDER BY id) AS xLead
		,lead(id,1,null) OVER (PARTITION BY stockname ORDER BY id) - id AS diff_lead
		,row_number() OVER (PARTITION BY stockname ORDER BY id) as xRow
INTO --drop table
#temp
FROM #tbl 

SELECT * FROM #temp

/*
stockname	id	xLead	diff_lead	xRow
AAPL		1	2		1			1
AAPL		2	3		1			2
AAPL		3	74		71			3
AAPL		74	75		1			4
AAPL		75	76		1			5
AAPL		76	100		24			6
AAPL		100	101		1			7
AAPL		101	102		1			8
AAPL		102	NULL	NULL		9
GOOGL		5	6		1			1
GOOGL		6	7		1			2
GOOGL		7	77		70			3
GOOGL		77	78		1			4
GOOGL		78	79		1			5
GOOGL		79	103		24			6
GOOGL		103	104		1			7
GOOGL		104	105		1			8
GOOGL		105	NULL	NULL		9
YAHOO		80	81		1			1
YAHOO		81	106		25			2
YAHOO		106	107		1			3
YAHOO		107	NULL	NULL		4
*/

-- Use the generated difference in leads and the ordered list of rows to get the number of rows from the starting point for each stockname.

SELECT stockname, min(id) as row_to_start, min(CASE WHEN diff_lead>1 THEN xRow ELSE null END) AS number_of_rows,
count(case when diff_lead>1 then xRow else null end)+1 as number_of_times_loaded
into #temp2
from #temp 
group by stockname
order by 2

select * from #temp2 order by 2

/*
stockname	row_to_start	number_of_rows	number_of_times_loaded
AAPL			1				3				3
GOOGL			5				3				3
YAHOO			80				2				2
*/

--Finally, put it all together and link it to the original table to get a filtered table
select a.* into #temp3 from #tbl a
inner join #temp2 b
on a.stockname = b.stockname and
a.id >= b.row_to_start and
a.id <= b.row_to_start + b.number_of_rows
order by 1

select * from #temp3 ORDER BY id
/*
id	stockname	data
1	AAPL		asdrfsdfgsdfsdghrege
2	AAPL		aegerfrvsfvahtjndzhdfgzfdgzdfbzedmtnd
3	AAPL		asdghergrefAEdf
5	GOOGL		bjjcunvcb  sdfgsd
6	GOOGL		 gxbxt3434t3fd
7	GOOGL		dztrz vdvdrv
80	YAHOO		nbmxbnxbzbvdfbdrt
81	YAHOO		ytdjkyhsxbf
*/

END;