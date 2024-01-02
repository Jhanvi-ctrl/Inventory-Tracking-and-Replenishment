SELECT sum(Fqty*1) AS TotalInventoryValue 
FROM `product2.0`.`product table`;


/*Identify low-stock products and also need restocking*/
SELECT Item,Description, Fqty
FROM `product2.0`.`product table`
WHERE Fqty < 100
order by Fqty Asc;

/*  Distribution of products across categories  */
SELECT Category, COUNT(*) AS ProductCount 
FROM `product2.0`.`product table`
GROUP BY Category
order by ProductCount Desc;

/* Filter products by category   */
SELECT * 
FROM `product2.0`.`product table`
WHERE Category = '321. Structured parts-12.smt small hardware'; 

/* Find products from a specific supplier   */
SELECT * 
FROM `product2.0`.`product table`
WHERE SupplierID = 'O28'; 


SELECT * FROM supplier.`supplier table`;
/* Determine the number of products supplied by each supplier */
SELECT s.SupplierID, s.Suppliername, count(p.item) as productcount
from supplier.`supplier table` s
JOIN `product2.0`.`product table` p ON s.SupplierID = p.SupplierID 
GROUP BY 
s.SupplierID, s.Suppliername
order by productcount desc limit 3;



/*Analyze shortages to identify products or suppliers that frequently fall short of expected quantities.*/
SELECT
    P.Item,P.Description,P.Category,P.Fqty AS ExpectedQuantity,P.Shortage,
    S.SupplierID,S.Suppliername,S.ContactPerson,S.Email
FROM`product2.0`.`product table` p
JOIN
    supplier.`supplier table` s ON p.SupplierID = s.SupplierID
WHERE p.Shortage > 0
ORDER BY p.Shortage DESC;
    
    
    /*Identify Suppliers with the Most Shortages*/
    
SELECT
    S.SupplierID,S.Suppliername,
    COUNT(P.Shortage) AS TotalShortages
FROM supplier.`supplier table` S
JOIN
     `product2.0`.`product table` P ON S.SupplierID = P.SupplierID
WHERE P.Shortage > 0
GROUP BY S.SupplierID, S.Suppliername
ORDER BY TotalShortages DESC;
    
/* Find Products with Persistent Shortages:*/
SELECT
    P.Item,P.Description,P.Category,
    COUNT(P.Shortage) AS TotalShortages
FROM `product2.0`.`product table` P
WHERE P.Shortage > 0
GROUP BY P.Item, P.Description, P.Category
ORDER BY TotalShortages DESC;


/*Calculate Average Shortage Quantity per Supplier*/
SELECT
    S.SupplierID, S.Suppliername, AVG(P.Shortage) AS AverageShortage
FROM supplier.`supplier table` S
JOIN
    `product2.0`.`product table` P ON S.SupplierID = P.SupplierID
WHERE P.Shortage > 0
GROUP BY S.SupplierID, S.Suppliername
ORDER BY AverageShortage DESC;
    
    
    
/* Explore Shortages in Specific Categories*/
SELECT
    P.Category, COUNT(P.Shortage) AS TotalShortages
FROM
   `product2.0`.`product table` P
WHERE P.Shortage > 0
GROUP BY P.Category
ORDER BY TotalShortages DESC;
    
/*Identify Contact Persons Associated with Fewest Shortages*/
SELECT
    S.ContactPerson,
    COUNT(P.Shortage) AS TotalShortages
FROM supplier.`supplier table` S
JOIN
     `product2.0`.`product table` P ON S.SupplierID = P.SupplierID
WHERE P.Shortage > 0
GROUP BY S.ContactPerson
ORDER BY TotalShortages ASC;
    
