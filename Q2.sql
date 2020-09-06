-- A1
SELECT count(distinct(OrderID))
FROM [Orders] A LEFT JOIN [Shippers] B ON A.ShipperID=B.ShipperID
WHERE ShipperName = 'Speedy Express'
-- 54


-- A2
SELECT B.LastName,
       count(distinct(OrderID)) AS total_order
FROM [Orders] A LEFT JOIN [Employees] B ON A.EmployeeID=B.EmployeeID
GROUP BY A.EmployeeID
ORDER BY total_order DESC 
LIMIT 1

-- LastName	total_order
-- Peacock   	40

-- A3
SELECT C.ProductName,
       C.ProductID,
       COUNT(A.OrderID) AS total_order,
       SUM(B.Quantity) AS Product_quant
FROM [Orders] A LEFT JOIN [OrderDetails] B ON A.OrderID=B.OrderID -- 196 and 518
				LEFT JOIN [Products] C ON B.ProductID=C.ProductID
				LEFT JOIN [Customers] D ON A.CustomerID=D.CustomerID
WHERE D.Country ='Germany'
GROUP BY C.ProductName,
         C.ProductID
ORDER BY Product_quant DESC 
LIMIT 1

-- ProductName	        ProductID	total_order	Product_quant
-- Boston Crab Meat	    40	        4	        160

SELECT C.ProductName,
       C.ProductID,
       COUNT(A.OrderID) AS total_order,
       SUM(B.Quantity) AS Product_quant
FROM [Orders] A LEFT JOIN [OrderDetails] B ON A.OrderID=B.OrderID -- 196 and 518
				LEFT JOIN [Products] C ON B.ProductID=C.ProductID
				LEFT JOIN [Customers] D ON A.CustomerID=D.CustomerID
WHERE D.Country ='Germany'
GROUP BY C.ProductName,
         C.ProductID
ORDER BY total_order DESC 
LIMIT 1

-- ProductName			ProductID	total_order		Product_quant
-- Gorgonzola Telino	31			5				125