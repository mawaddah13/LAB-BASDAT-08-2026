SET search_path TO classicmodels, public;


SELECT
	productcode,
	productname,
	productline,
	buyprice
FROM products AS p
WHERE buyprice = (
	SELECT MAX(buyprice)
	FROM products
)
ORDER BY productline;