Use Store;
-- Create view Invoice_view AS
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