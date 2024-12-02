Drop database Store;
create database Store;
USE Store;
Create table tbSuppliers(
	supID int primary key auto_increment,
	Supplier nvarchar(255) NOT NULL,
	SupAdd	nvarchar(255) NOT NULL,
	SupCon varchar(255)
);
create table tbStaffs(
	staffID int Primary key auto_increment,
    FullName nvarchar(255) NOT NULL,
    Gen		char NOT NULL,
    Dob	date NOT NULL,
    Position	varchar(255) NOT NULL,
    Salary		Decimal(7,2) NOT NULL,
    StopWork BIT 
);
create table tbCustomers(
	cusID int primary key auto_increment,
    CusName nvarchar(255) NOT NULL
);
create table tbProducts(
	ProCode int primary key auto_increment,
    ProName varchar(255) NOT NULL,
    Descriptions varchar(255)
);
create table tbImports(
	ImpID int primary key auto_increment,
    ImpDate date NOT NULL,
    staffID int ,
    supID int,
    foreign key(staffID) REFERENCES tbStaffs(staffID),
    foreign key(supID) REFERENCES tbSuppliers(supID)
);
create table tbImportDetail(
	ImpID int,
    ProCode int,
    inven smallint NOT NULL,
    Price Decimal(5,2),
    Amount decimal(10,2),
    foreign key(ImpID) REFERENCES tbImports(ImpID),
    foreign key(ProCode)REFERENCES tbProducts(ProCode)
);
create table tbInvoices(
	InvCode int primary key  auto_increment,
    InvDate date NOT NULL,
    staffID int, 
    cusID int ,
    foreign key(staffID) REFERENCES tbStaffs(staffID),
    foreign key(cusID) REFERENCES tbCustomers(cusID)
);
create table tbInvoiceDetail(
	InvCode int,
    ProCode int,
    qty smallint NOT NULL,
    Price decimal(5,2),
    Amount decimal(10,2),
    foreign key (ProCode) REFERENCES tbProducts(ProCode),
    foreign key (InvCode) REFERENCES tbInvoices(InvCode)
);
create table tbPayments(
	PayCode int primary key  auto_increment,
    PayDate date NOT NULL,
    staffID int,
    InvCode int,
	Amount decimal(5,2) default 0.00,
    foreign key (staffID) REFERENCES tbStaffs(staffID),
    foreign key (InvCode) REFERENCES tbInvoices(InvCode)
);
	



