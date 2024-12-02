Use Store;
-- Create view staffsimport_view AS
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
