use store;
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

