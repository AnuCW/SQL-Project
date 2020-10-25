--Challege: 1- Retrieve Customers Data


--Retrieve Customers all details
select * from [SalesLT].[Customer];

--Retrieve customers name details
select Title, FirstName, MiddleName, LastName from [SalesLT].[Customer];

--Retrieve call sheet for salespersons
select Title+LastName as CustomerName, Phone, SalesPerson from [SalesLT].[Customer];

--Challenge :2 - Retrieve Customer & Sales Data


-- List of Customer Companies in a format <CustomerID> : <Company Name>
select cast(CustomerID as nvarchar) + ':' + ' ' + CompanyName  as CustomerCompany from [SalesLT].[Customer];

-- Report that shows sales order number and revision number in the format <Order Number> (<Revision>) and order date to yyyy.mm.dd format
select * from [SalesLT].[SalesOrderHeader];
select salesordernumber+ ' ' + '('+cast(RevisionNumber as nvarchar)+')' as SalesOrderWithRevision, convert(nvarchar(30), orderdate, 102) as ANSIFormatConvertedDate
From [SalesLT].[SalesOrderHeader]; 

-- Challenge :3 - Retrieve Customer Contact Details


-- Retrieve Customer Names with middle names if known
select firstname+ ' '+isnull(middlename, ' ')+' '+lastname as CustomerName
from [SalesLT].[Customer];

-- Retrieve primary contact details

update [SalesLT].[Customer]
set emailaddress = null
where customerid % 7 = 1;
select customerId,
isnull(emailaddress, ' ')+ ' ' + phone as PrimaryContact
from [SalesLT].[Customer];

-- Retrieve Shipping Status
Update [SalesLT].[SalesOrderHeader]
Set ShipDate = Null
Where SalesOrderId > 71899;
select salesOrderId, orderDate,
    (case 
        when ShipDate is null then 'Awaiting shipment'
        Else 'Shipped'
    End) as ShippingStatus
from [SalesLT].[SalesOrderHeader];


-- Lab:2 
-- Challenge:1 - Retrieve Data for Transportation Reports


-- Retrieve List of cities, remove duplicates
select Distinct stateprovince, City
from [SalesLT].[Address]
order by stateprovince;

-- Top ten percent of products by weight
select count(*) from [SalesLT].[Product];
select top 10 percent Name, weight
from [SalesLT].[Product]
order by weight desc ;
select count(*) from 
( 
    select top 10 percent Name, weight
    from [SalesLT].[Product]
    order by weight desc 
) as no_of_rows;
select max (weight) from [SalesLT].[Product];

-- list of heaviest 100 products not including the heaviest ten
select name, weight
from [SalesLT].[Product]
order by weight desc 
offset 10 rows 
fetch next 100 rows only;

-- challenge:2 - Retrieve Product Data


-- retrieve product detail for product model 1
select name, color, size
from [SalesLT].[Product]
where ProductmodelID = 1;

-- retrieve product number and name that have color black, red or white and a size of S or M
select productnumber, name+ ' ' + color as PName
from [SalesLT].[Product]
where color in ('black', 'red', 'white') and size in ('S', 'M');

-- retrieve details where product number begins with BK
select productnumber, Name, ListPrice 
from [SalesLT].[Product]
where productnumber like 'BK-%' ;

-- retrieve details where product number begins with BK followed by any character other than 'R' and ends with '-' followed by two numerals
select productnumber, Name, ListPrice 
from [SalesLT].[Product]
where productnumber like 'BK-[^R]%-[0-9][0-9]';


-- Lab:3 - Generate Invoice Reports


-- Retrieve Customer Orders
select cust.CompanyName, cust.customerID, soh.SalesOrderID, soh.TotalDue
from [SalesLT].[Customer] as cust 
join [SalesLT].[SalesOrderHeader] as soh 
ON cust.customerID = soh.customerID; 

-- Retrieve Customer Orders with Addresses
select ISnull(AddressLine1,' ')+','+ ' ' +isnull(AddressLine2, ' ')+','+' '+isnull(City, ' ' )+','+' '+isnull(StateProvince, ' ')+','+' '+isnull(countryRegion,' ')+','+' '+isnull(PostalCode,' ')as MainOfficeAddress,
cust.CompanyName, soh.SalesOrderID, soh.TotalDue
from [SalesLT].[Address] as ads  
join [SalesLT].[CustomerAddress] as custadd on custadd.AddressID = ads.AddressID
join [SalesLT].[Customer] as cust on cust.CustomerID = custadd.customerID
join [SalesLT].[SalesOrderHeader] as soh On soh.customerID = cust.customerID;

-- retrieve a list of all customers and their orders
select cust.CompanyName, cust.FirstName+ ' ' +cust.LastName as Contact, soh.salesorderID, soh.totaldue
from [SalesLT].[Customer] as cust  
left join [SalesLT].[SalesOrderHeader] as soh  on cust.customerID = soh.customerID
order by soh.totaldue desc;

-- retrieve list of customers details with no address
select cust.customerID, cust.companyname, cust.firstname+ ' ' +lastname as Contact, cust.phone
from [SalesLT].[Customer] as cust 
full join [SalesLT].[CustomerAddress] as custadd on cust.customerid = custadd.customerid
full join [SalesLT].[Address] as a on custadd.addressid = a.addressid
where a.addressid is null;

-- retrieve a list of customers and products without orders
select cust.customerID, p.productID
from [SalesLT].[Customer] as cust 
full join [SalesLT].[SalesOrderHeader] as soh on cust.customerID = soh.customerID
full join [SalesLT].[SalesOrderDetail] as sod on soh.salesorderID = sod.salesorderID
full join [SalesLT].[Product] as p on sod.productID = p.productID
where p.productid is null or cust.customerid is null;

-- Lab 4: Challenge 1: Retrieve Customer Addresses


-- retrieve billing address
select cust.companyname, a.addressline1+','+ ' ' +city as BillingAddress, custadd.addresstype
from [SalesLT].[CustomerAddress] as custadd  
join [SalesLT].[Address] as a  on custadd.addressid = a.addressid 
join [SalesLT].[Customer] as cust on cust.customerid = custadd.customerid
where addresstype = 'Main Office';

-- retrieve shipping address
select cust.companyname, a.addressline1+','+ ' ' +city as ShippingAddress, custadd.addresstype
from [SalesLT].[CustomerAddress] as custadd  
join [SalesLT].[Address] as a  on custadd.addressid = a.addressid 
join [SalesLT].[Customer] as cust on cust.customerid = custadd.customerid
where addresstype = 'Shipping';

-- combine billing and shipping addresses
select cust.companyname, a.addressline1+','+ ' ' +city as BillingAddress, custadd.addresstype
from [SalesLT].[CustomerAddress] as custadd  
join [SalesLT].[Address] as a  on custadd.addressid = a.addressid 
join [SalesLT].[Customer] as cust on cust.customerid = custadd.customerid
where addresstype = 'Main Office'
union all
select cust.companyname, a.addressline1+','+ ' ' +city as ShippingAddress, custadd.addresstype
from [SalesLT].[CustomerAddress] as custadd  
join [SalesLT].[Address] as a  on custadd.addressid = a.addressid 
join [SalesLT].[Customer] as cust on cust.customerid = custadd.customerid
where addresstype = 'Shipping'
order by cust.companyname, custadd.addresstype;

-- Challenge 2: Filter Customer Addresses

-- retrieve customers with only main office addressess
select cust.companyname
from [SalesLT].[Customer] as cust 
where customerid in (
                        select custadd.customerid 
                        from [SalesLT].[CustomerAddress] as custadd 
                        where addresstype = 'Main Office'
                        except
                        select custadd.customerid
                        from [SalesLT].[CustomerAddress] as custadd 
                        where addresstype = 'Shipping'
                    )
                    
-- Retrieve only customers with both a main office address and a shipping address
select cust.companyname
from [SalesLT].[Customer] as cust 
where customerid in (
                        select custadd.customerid 
                        from [SalesLT].[CustomerAddress] as custadd 
                        where addresstype = 'Main Office'
                        intersect
                        select custadd.customerid
                        from [SalesLT].[CustomerAddress] as custadd 
                        where addresstype = 'Shipping');

-- Lab 5: Retrieve Product Information

-- Challenge 1: Retrieve Product Information

-- Retrieve the name and approx weight of each product
select concat(productid,' ',upper(name)), round(weight, 0) as ApproxWeight from [SalesLT].[Product];

-- Retrieve the year & month in which products were first sold
select concat(productid,' ',upper(name)), round(weight, 0) as ApproxWeight, year(sellstartdate) as SellStartYear, datename(month,sellstartdate) as SellStartMonth from [SalesLT].[Product];

-- Extract product types from product numbers
select concat(productid,' ',upper(name)) ProductDetails, left(productnumber, 2) ProductType, round(weight, 0) as ApproxWeight, year(sellstartdate) as SellStartYear, datename(month,sellstartdate) as SellStartMonth from [SalesLT].[Product];

-- Retrieve only products with a numeric size
select size, concat(productid,' ',upper(name)) ProductDetails, left(productnumber, 2) ProductType, round(weight, 0) as ApproxWeight, year(sellstartdate) as SellStartYear, datename(month,sellstartdate) as SellStartMonth 
from [SalesLT].[Product]
where isnumeric(size) = 1;

-- Challenge 2 : Rank customers by Revenue

-- Retrieve companies ranked by sales totals
select CustomerID,
rank() over(order by totalDue Desc) Rank
from [SalesLT].[SalesOrderHeader];

-- Challenge 3 : Aggregate Product SaLes

-- Retrieve total sales by product
select P.name, sum(SOD.linetotal) As TotalRevenue 
from [SalesLT].[Product] P 
Join [SalesLT].[SalesOrderDetail] SOD 
ON P.productID = SOD.productID
Group by name
order by TotalRevenue Desc;

-- Filter the product sales list to include only products that cost over $1,000

select P.name, sum(SOD.linetotal) As TotalRevenue 
from [SalesLT].[Product] P 
Join [SalesLT].[SalesOrderDetail] SOD 
ON P.productID = SOD.productID
WHERE p.listprice> 1000
Group by name
order by TotalRevenue Desc;

-- Filter the product sales groups to include only total sales over $20,000
select P.name, sum(SOD.linetotal) As TotalRevenue 
from [SalesLT].[Product] P 
Join [SalesLT].[SalesOrderDetail] SOD 
ON P.productID = SOD.productID
Group by name
having sum(SOD.linetotal)>20000
order by TotalRevenue Desc;

-- Lab 6 : Using Subqueries and APPLY

-- Challenge 1: Retrieve Product Price Information

-- Retrieve products whose list price is higher than the average unit price
select productid, name, listprice 
from [SalesLT].[Product]
where listprice>
(select avg(unitprice) from [SalesLT].[SalesOrderDetail]);

-- Retrieve Products with a list price of $100 or more that have been sold for less than $100
select productid, name, listprice
from [SalesLT].[Product]
where listprice >=100 
And productid IN
(select productid from [SalesLT].[SalesOrderDetail] 
where unitprice<100);

-- Retrieve the cost, list price, and average selling price for each product
select p.productid, p.name, p.standardcost, p.listprice, 
(select avg(sod.unitprice) from [SalesLT].[SalesOrderDetail] sod
where sod.productid = p.productid) AverageUnitPrice 
from [SalesLT].[Product] p;

-- Retrieve products that have an average selling price that is lower than the cost
select p.productid, p.name, p.standardcost, p.listprice, 
(select avg(sod.unitprice) from [SalesLT].[SalesOrderDetail] sod
where sod.productid = p.productid) AverageUnitPrice 
from [SalesLT].[Product] p
where p.standardcost > 
(select avg(sod.unitprice) from [SalesLT].[SalesOrderDetail] sod 
where p.productid=sod.productid);

-- Challenge 2: Retrieve Customer Information

-- Retrieve customer information for all sales orders
select soh.salesorderid, ci.customerid, ci.firstname, ci.lastname, soh.totaldue
from [SalesLT].[SalesOrderHeader] soh 
cross apply 
dbo.ufnGetCustomerInformation(soh.customerid) as ci;

-- Retrieve customer address information
select ci.customerid, ci.firstname, ci.lastname, a.addressline1, a.city 
from [SalesLT].[CustomerAddress] as ca 
join [SalesLT].[Address] as a 
ON a.addressid = ca.addressid
cross apply 
dbo.ufnGetCustomerInformation(ca.customerid) as ci;

-- Lab 7 : Using Table Expressions

-- Challenge 1: Retrieve Product Information

-- Retrieve product model descriptions
select p.productId, p.name, pmcd.name, pmcd.summary
from [SalesLT].[Product] as p 
join [SalesLT].[vProductModelCatalogDescription] as pmcd 
on pmcd.productmodelid = p.productmodelid;

-- Create a table of distinct colors
Declare @colors table(color varchar(20));
Insert into @colors
select distinct color 
from [SalesLT].[Product]; 
select productid, name, color 
from [SalesLT].[Product]
where color IN
(select * from @colors);

-- Retrieve product parent categories
select p.productid, p.name, gac.productcategoryname, gac.parentproductcategoryname
from [SalesLT].[Product] as p 
join dbo.ufnGetAllCategories() as gac 
on gac.productcategoryid = p.productcategoryid;

-- Challenge 2: Retrieve Customer Sales Revenue

-- Retrieve sales revenue by customer and contact
With CompanySummary (contactname, TotalRevenue)
AS  
(select concat(c.firstname,' ', c.lastname) AS ContactName, soh.totalDue TotalRevenue
from [SalesLT].[Customer] as c 
join [SalesLT].[SalesOrderHeader] as soh 
on soh.customerid = c.customerid)
select ContactName, sum(TotalRevenue) as TotalRevenue
from Companysummary
group by ContactName
order by TotalRevenue DESC;

-- Lab 8 – Grouping Sets and Pivoting Data

-- Challenge 1: Retrieve Regional Sales Totals

-- Retrieve totals for country/region and state/province
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY rollup(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

-- Indicate the grouping level in the results
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue,
CASE 
	WHEN GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1 THEN 'Total'
	WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 1 THEN CONCAT(a.CountryRegion, ' Subtotal')
	WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 0 THEN CONCAT(a.StateProvince, ' Subtotal')
END AS Level
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY rollup(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

-- Add a grouping level for cities
SELECT a.CountryRegion, a.StateProvince, a.city, SUM(soh.TotalDue) AS Revenue,
CASE 
	WHEN GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1 AND GROUPING_ID(a.city) = 1 THEN 'Total'
	WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 1 AND GROUPING_ID(a.city) = 1 THEN CONCAT(a.CountryRegion, ' Subtotal')
	WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 0 AND GROUPING_ID(a.city) = 1 THEN CONCAT(a.StateProvince, ' Subtotal')
    WHEN GROUPING_ID(a.CountryRegion) = 0 AND GROUPING_ID(a.StateProvince) = 0 AND GROUPING_ID(a.city) = 0 THEN CONCAT(a.city, ' Subtotal')
END AS Level
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY rollup(a.CountryRegion, a.StateProvince, a.city)
ORDER BY a.CountryRegion, a.StateProvince, a.city;

-- Challenge 2: Retrieve Customer Sales Revenue by Category

-- Retrieve customer sales revenue for each parent category
select * from 
(
    select c.companyname, vgac.parentproductcategoryname, sod.linetotal as TotalRevenue
    from [SalesLT].[Customer] as c 
    join [SalesLT].[SalesOrderHeader] as soh on soh.customerid = c.customerid
    join [SalesLT].[SalesOrderDetail] as sod on sod.salesorderid = soh.salesorderid
    join [SalesLT].[Product] as p on p.productid=sod.productid
    join [SalesLT].[vGetAllCategories] as vgac on vgac.productcategoryid = p.productcategoryid
) as cn 
Pivot 
(
    sum(TotalRevenue) 
        FOR [ParentProductCategoryName] IN ([Accessories], [Bikes], [Clothing], [Components])
)as pcn;

