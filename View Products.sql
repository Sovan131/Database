Use Store;
-- Create view Products_view AS
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