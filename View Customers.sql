Use Store;
-- Create view Customer_view AS
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