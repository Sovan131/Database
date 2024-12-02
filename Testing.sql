INSERT INTO tbcustomers (cusname)
	select * FROM (SELECT icusname) AS TEMP
	WHERE NOT EXISTS (
    SELECT name FROM tbcustomers WHERE name  =icusname
)LIMIT 1;