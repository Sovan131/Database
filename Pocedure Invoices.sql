use store;
DELIMITER //
CREATE PROCEDURE saveinvoice	(IN icusname VARCHAR(255) ,
								 IN iprocode INT,
                                 IN iQty smallint,
                                 IN istaffid int)
BEGIN 
	INSERt INTO tbcustomers(cusname)
    SELECT icusname
    WHERE NOT EXISTS(
		SELECT 1 FROM tbcustomers WHERE CusName=icusname);
    insert into tbinvoices(invdate, staffid, cusid)
    values(current_date(),istaffid,(select cusID from tbcustomers where cusname = icusname));
    insert into tbinvoicedetail(invcode,procode,qty,price)
    values((select count(invcode) from tbinvoices), iprocode, iqty,(select max(price)from tbimportdetail where procode =iprocode));
    insert into tbpayments(paydate, staffid, invcode, amount)
    values(current_date(),istaffid, (select count(invcode) from tbinvoices),iqty*(select max(price)from tbimportdetail where procode =iprocode));
END //

DELIMITER ;


DELIMITER //
CREATE PROCEDURE searchinvoice	(IN icusname varchar(255),
								 IN iinvcode int)

BEGIN
	SELECT * from invoice_view 
    WHERE customer_name = icusname OR invcode = iinvcode;
END //

DELIMITER ;