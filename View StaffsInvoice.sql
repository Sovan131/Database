Use Store;
-- Create view staffsinvoice_view AS
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
