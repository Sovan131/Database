use store;
CREATE TRIGGER import_totalamount
BEFORE INSERT ON tbimportdetail
FOR EACH ROW
Set new.amount =(new.inven * new.price);


CREATE TRIGGER invoice_totalamount
BEFORE INSERT ON tbinvoicedetail
FOR EACH ROW
Set new.amount =(new.qty * new.price);

DELIMITER  $$

CREATE TRIGGER inventory_update
AFTER INSERT ON tbinvoicedetail
FOR EACH ROW
BEGIN
	DECLARE pcode int;
    SELECT procode
    INTO pcode
    FROM tbinvoicedetail
    WHERE ProCode=new.ProCode;
    
    UPDATE  tbimportdetail
    SET inven = inven - new.qty
	WHERE procode = pcode;
	
END$$

DELIMITER ;

