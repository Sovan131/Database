use store;
DELIMITER //
CREATE PROCEDURE savesupplier	(IN isup VARCHAR(255) ,
								 IN isupcon VARCHAR(255) ,
								 IN isupadd VARCHAR(255))
BEGIN 
	INSERT INTO tbsuppliers(Supplier, SupAdd, SupCon)
	VALUES  (isup, isupadd,isupcon);

    
END //

DELIMITER ;


DELIMITER //
CREATE PROCEDURE updatesupplier (IN isupid int,
								 IN isup VARCHAR(255) ,
								 IN isupcon VARCHAR(255) ,
								 IN isupadd VARCHAR(255))
BEGIN
	UPDATE tbsuppliers
    SET supplier = isup, supcon = isupcon, supadd = isupadd
    WHERE supid = isupid;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE searchsupplier 	(IN iid int,
									IN isupplier varchar(255))
BEGIN
	SELECT * FROM suppliers_view 
    WHERE id=iid OR isupplier = supplier;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE deletesupplier (IN isupid int,
								IN isupplier varchar(255))
BEGIN
	DELETE FROM tbsuppliers 
	WHERE supid = isupid OR supplier = isupplier;
END //

DELIMITER ;