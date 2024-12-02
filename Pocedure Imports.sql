use store;

DELIMITER //
CREATE PROCEDURE saveimport		(IN iproname VARCHAR(255) ,
								 IN ides VARCHAR(255),
                                 IN iinven smallint,
                                 IN iprice decimal(5,2),
                                 IN istaffid int,
                                 IN isupid int)
BEGIN 
    INSERT INTO tbproducts(proname,descriptions)
    VALUES(iproname, ides);
    INSERT INTO tbimports(impdate, staffid, supid)
    VALUES(current_date(),istaffid,isupid);
    INSERT INTO tbimportdetail(impid, procode, inven, price)
	VALUES	((SELECT COUNT(impid) from store.tbimports),(SELECT COUNT(procode)FROM store.tbproducts),iinven,iprice);
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE deleteimport (IN iid int)
BEGIN 
	DELETE FROM tbimports
    WHERE impID = iid;
    DELETE FROM tbimportdetail
    WHERE impid = iid;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE searchimport 	(IN iid int,
								IN iproname VARCHAR(255))
BEGIN
	SELECT * FROM import_view
    WHERE impid = iid OR proname = iproname;
END//

DELIMITER ;
DELIMITER //

CREATE PROCEDURE updateimport 	(IN iid int,
								IN iprice int)
BEGIN
	UPDATE tbimportdetail
    SET price = iprice
    WHERE impid = iid;
END//

DELIMITER ;


