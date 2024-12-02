use store;
-- CREATE VIEW Import_view AS
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
on sta.staffid = imp.staffid

