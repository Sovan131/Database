-- CREATING TABLE
Drop database Store;
create database Store;
USE Store;
Create table tbSuppliers(
	supID int primary key auto_increment,
	Supplier nvarchar(255) NOT NULL,
	SupAdd	nvarchar(255) NOT NULL,
	SupCon varchar(255)
);
create table tbStaffs(
	staffID int Primary key auto_increment,
    FullName nvarchar(255) NOT NULL,
    Gen		char NOT NULL,
    Dob	date NOT NULL,
    Position	varchar(255) NOT NULL,
    Salary		Decimal(7,2) NOT NULL,
    StopWork BIT 
);
create table tbCustomers(
	cusID int primary key auto_increment,
    CusName nvarchar(255) NOT NULL
);
create table tbProducts(
	ProCode int primary key auto_increment,
    ProName varchar(255) NOT NULL,
    Descriptions varchar(255)
);
create table tbImports(
	ImpID int primary key auto_increment,
    ImpDate date NOT NULL,
    staffID int ,
    foreign key(staffID) REFERENCES tbStaffs(staffID),
    supID int,
    foreign key(supID) REFERENCES tbSuppliers(supID)
);
create table tbImportDetail(
	ImpID int,
    foreign key(ImpID) REFERENCES tbImports(ImpID),
    ProCode int,
    foreign key(ProCode)REFERENCES tbProducts(ProCode),
    inven smallint NOT NULL,
    Price Decimal(5,2),
    Amount decimal(10,2)
);
create table tbInvoices(
	InvCode int primary key  auto_increment,
    InvDate date NOT NULL,
    staffID int, 
    foreign key(staffID) REFERENCES tbStaffs(staffID),
    cusID int ,
    foreign key(cusID) REFERENCES tbCustomers(cusID)
);
create table tbInvoiceDetail(
	InvCode int,
    foreign key (InvCode) REFERENCES tbInvoices(InvCode),
    ProCode int,
    foreign key (ProCode) REFERENCES tbProducts(ProCode),
    qty smallint NOT NULL,
    Price decimal(5,2),
    Amount decimal(10,2)
);
create table tbPayments(
	PayCode int primary key  auto_increment,
    PayDate date NOT NULL,
    staffID int,
    foreign key (staffID) REFERENCES tbStaffs(staffID),
    InvCode int,
    foreign key (InvCode) REFERENCES tbInvoices(InvCode),
	Amount decimal(5,2) default 0.00
);


-- CREATING TRIGGERS

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

-- INSERT INTO TABLEs


USE Store;
INSERT INTO tbsuppliers
		(Supplier, SupAdd, SupCon)
VALUES  ("LUCKY", "PP","012482619"),
		("CHIP MONG","PP","012759262"),
        ("AEON MALL","PP","012659362");
INSERT INTO tbstaffs(fullname, gen,dob,position,salary,stopwork)
VALUES	("Meng Chandara","M",'2001-01-01',"Manager","899.99",0),
		("Doung Mengly","M",'2001-05-05',"Employee","499.99",0),
        ("Chan Kaknika","F","2002-01-05","Employee","599.999",0);
INSERT INTO tbcustomers(cusname)
VALUES	("Sok Keav"),
        ("Sey Pholly"),
        ("Meng Pheak");
INSERT INTO tbproducts(proname, descriptions)
VALUES	("Sting","Stawbarry flavored drink with 330mL can"),
		("Cocacola","Original cocacola flavor with 330mL can"),
		("Vital","Premium drinking water with 500mL bottle");
INSERT INTO tbimports(impdate, staffid, supid)
VALUES 	('2023-10-10',1,1),
		('2023-11-11',1,2),
        ('2023-12-11',2,3);
INSERT INTO tbimportdetail(impid, procode, inven, price)
VALUES	(1,1,500, 0.50),
		(2,2,1000,0.45),
        (3,3,1000,0.25);
INSERT INTO tbinvoices(invdate, staffid, cusid)
VALUES 	('2024-01-01',1,2),
		('2024-02-01',1,3),
        ('2024-02-02',2,1);
INSERT INTO tbinvoicedetail(invcode, procode, qty, price)
VALUES	(1,1,20,0.50),
		(2,2,10,0.45),
		(3,3,20,0.25);
INSERT INTO tbpayments(paydate, staffid, invcode, amount)
VALUES	('2024-01-02',1,1,10),
		('2024-02-02',2,2,4.5),
        ('2024-01-03',1,3,5);








-- CREATING PROCEDURE

DELIMITER //
CREATE PROCEDURE saveinvoice	(IN icusname VARCHAR(255) ,
								 IN iprocode INT,
                                 IN iQty smallint,
                                 IN istaffid int)
BEGIN 
	DECLARE cur_inv int;
    DECLARE iprice decimal(5,2);
    select count(invcode)+1 into cur_inv from tbinvoices LIMIT 1;
    select max(price) into iprice from tbimportdetail where procode =iprocode LIMIT 1;
    
	INSERt INTO tbcustomers(cusname)
    SELECT icusname
    WHERE NOT EXISTS(
		SELECT 1 FROM tbcustomers WHERE CusName=icusname);
    insert into tbinvoices(invdate, staffid, cusid)
    values(current_date(),istaffid,(select cusID from tbcustomers where cusname = icusname));
    
    
    insert into tbpayments(paydate, staffid, invcode, amount)
    values(current_date(),istaffid, (select count(invcode) from tbinvoices),(Select amount from tbinvoicedetail where invcode = cur_inv));
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

DELIMITER //
CREATE PROCEDURE savestaff		(IN istaffname VARCHAR(255) ,
								 IN igen char,
                                 IN idob date,
                                 IN iposition varchar(255),
                                 IN isalary decimal(7,2))
BEGIN 
    INSERT INTO tbstaffs(fullname, gen,dob,position,salary,stopwork)
	VALUES	(istaffname,igen,idob,iposittion,isalary,0);
END //

DELIMITER ;

CREATE PROCEDURE deletestaff  (IN istaffid int,
							IN istaffname varchar(255))
UPDATE tbstaffs
SET stopwork = 1
WHERE staffid = istaffid OR fullname = istaffname;


DELIMITER //

CREATE PROCEDURE upatestaff (IN istaffname varchar(255),
							IN iposition varchar(255),
                            IN isalary decimal(7,2))
BEGIN
	UPDATE tbstaffs
    SET position = iposition, salary = isalary
    WHERE fullname = istaffname;
END // 

DELIMITER ;

DELIMITER //
CREATE PROCEDURE searchstaff	(IN iid int ,
								IN iname varchar(255))
BEGIN
	SELECT * FROM Staffsinfo_view
    WHERE id=iid OR fullname=iname;
END // 

DELIMITER ;

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


-- CREATING VIEW

Create view Customer_view AS
SELECT cus.cusid as ID, CusName as Customer_Name, inv.Invcode, inv.InvDate, pro.ProCode, ProName, invd.Qty, invd.Price, invd.Amount , PayCode, PayDate, pay.Amount as Paid, Fullname as Handle_by
From tbinvoicedetail as invd
left join  tbinvoices as inv
on invd.invcode = inv.invcode
right join tbcustomers as cus
on cus.cusID = inv.cusID
left join tbstaffs as sta
on sta.staffID = inv.staffID
left join tbproducts as pro
on pro.ProCode = invd.proCode
left join tbpayments as pay
on pay.invcode = inv.invcode
order by ID asc;

CREATE VIEW Import_view AS
SELECT imp.ImpID, Impdate as DATE, pro.ProCode, ProName, inven as Stock, Price, impd.amount, Descriptions,
		sta.fullname as Handled_by, sup.SupID, Supplier, Supadd as Address, supcon as Contact
from tbimports as imp
left join tbimportdetail as impd
on imp.impid = impd.impid
left join tbproducts as pro
on pro.ProCode = impd.procode
left join tbsuppliers as sup
on imp.supID = sup.supID
left join tbstaffs as sta
on sta.staffid = imp.staffid;

Create view Invoice_view AS
SELECT inv.Invcode, inv.InvDate, CusName as Customer_Name, sta.StaffID, pro.ProCode, pro.ProName, invd.Qty, invd.Price, invd.Amount, pay.Amount as Paid
From tbinvoicedetail as invd
left join  tbinvoices as inv
on invd.invcode = inv.invcode
left join tbcustomers as cus
on cus.cusID = inv.cusID
left join tbstaffs as sta
on sta.staffID = inv.staffID
left join tbproducts as pro
on pro.ProCode = invd.proCode
left join tbimportdetail as impd
on impd.ProCode = pro.ProCode
left join tbpayments as pay
on pay.invcode = inv.invcode
left join tbimports as imp
on imp.ImpID = impd.ImpID
left join tbsuppliers as sup
on sup.supID = imp.supID
order by invcode asc;

Create view payment_view AS
SELECT  PayCode, PayDate, inv.Invcode, inv.InvDate, pay.Amount as Paid, cus.cusid as ID, CusName as Customer_Name, pro.ProCode, ProName, invd.Qty, invd.Price, invd.Amount ,Fullname as Handle_by
From tbinvoicedetail as invd
left join  tbinvoices as inv
on invd.invcode = inv.invcode
Left join tbcustomers as cus
on cus.cusID = inv.cusID
left join tbstaffs as sta
on sta.staffID = inv.staffID
left join tbproducts as pro
on pro.ProCode = invd.proCode
left join tbpayments as pay
on pay.invcode = inv.invcode;

Create view Products_view AS
SELECT 	pro.ProCode as Code, pro.ProName as Product, impd.Price, impd.inven as Stock, impd.amount as est_Earn,
		(SELECT SUM(amount)from tbinvoicedetail where CODE = tbinvoicedetail.procode) as Total_Earned, sta.FullName as Handled_by, Supplier
From tbinvoicedetail as invd
LEFT join  tbinvoices as inv
on invd.invcode = inv.invcode
left join tbstaffs as sta
on sta.staffID = inv.staffID
RIGHT join tbproducts as pro
on pro.ProCode = invd.proCode
left join tbimportdetail as impd
on impd.ProCode = pro.ProCode
left join tbpayments as pay
on pay.invcode = inv.invcode
left join tbimports as imp
on imp.ImpID = impd.ImpID
left join tbsuppliers as sup
on sup.supID = imp.supID;

Create view staffsimport_view AS
SELECT  sta.StaffID, sta.FullName, imp.ImpID, pro.ProCode, pro.ProName, Inven, Price, Amount, sup.SupID, Supplier, SupAdd as Address, SupCon as Contact
FROM tbstaffs as sta
RIGHT JOIN tbimports as imp
ON imp.staffid = sta.staffid
LEFT JOIN tbimportdetail as impd
ON impd.impid = imp.impid
LEFT JOIN tbsuppliers as sup
ON imp.supID = sup.supID
LEFT JOIN tbproducts as pro
ON impd.ProCode = pro.ProCode
ORDER BY staffID ASC;

Create view staffsinfo_view AS
SELECT  StaffID as ID, FullName, gen as SEX, dob as Date_of_Birth, Position, Salary, StopWork 
FROM tbstaffs
ORDER BY staffID ASC;

Create view staffsinvoice_view AS
SELECT  sta.StaffID, sta.FullName, inv.Invcode, inv.InvDate, CusName as Customer_Name, pro.ProCode, pro.ProName, invd.Qty, invd.Price, invd.Amount, pay.Amount as Paid
FROM tbstaffs as sta
RIGHT JOIN tbinvoices as inv
ON inv.staffID = sta.staffid
LEFT JOIN tbcustomers as cus
ON inv.cusID = cus.cusID
LEFT JOIN tbinvoicedetail as invd
ON invd.InvCode = inv.invcode
LEFT JOIN tbproducts as pro
ON pro.ProCode = invd.procode
LEFT JOIN tbpayments as pay
ON inv.InvCode = pay.InvCode
ORDER BY staffID ASC;

Create view suppliers_view AS
SELECT 	sup.supID as ID, Supplier, SupAdd as Address, SupCon as Contact, pro.ProCode as Code, pro.ProName as Product, impd.Price, impd.inven as Stock, impd.amount as est_Earn,
		(SELECT SUM(amount)from tbinvoicedetail where CODE = tbinvoicedetail.procode) as Total_Earned, sta.FullName as Handled_by
From tbinvoicedetail as invd
LEFT join  tbinvoices as inv
on invd.invcode = inv.invcode
left join tbstaffs as sta
on sta.staffID = inv.staffID
RIGHT join tbproducts as pro
on pro.ProCode = invd.proCode
left join tbimportdetail as impd
on impd.ProCode = pro.ProCode
left join tbpayments as pay
on pay.invcode = inv.invcode
right join tbimports as imp
on imp.ImpID = impd.ImpID
left join tbsuppliers as sup
on sup.supID = imp.supID;




