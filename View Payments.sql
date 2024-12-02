Use Store;
-- Create view payment_view AS
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
on pay.invcode = inv.invcode
