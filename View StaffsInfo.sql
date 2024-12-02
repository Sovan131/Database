Use Store;
-- Create view staffsinfo_view AS
SELECT  StaffID as ID, FullName, gen as SEX, dob as Date_of_Birth, Position, Salary, StopWork 
FROM tbstaffs
ORDER BY staffID ASC;
