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
VALUE	(1,1,20,0.50),
		(2,2,10,0.45),
		(3,3,20,0.25);
INSERT INTO tbpayments(paydate, staffid, invcode, amount)
VALUES	('2024-01-02',1,1,10),
		('2024-02-02',2,2,4.5),
        ('2024-01-03',1,3,5);





