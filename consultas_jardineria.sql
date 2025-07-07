-- 1. Información básica de las oficinas
SELECT officeCode, city, country, phone
FROM offices;

-- 2. Empleados por oficina
SELECT o.officeCode, e.firstName, e.lastName, e.jobTitle
FROM employees e
JOIN offices o USING (officeCode)
ORDER BY o.officeCode;

-- 3. Promedio de límite de crédito por región
SELECT region, AVG(creditLimit) AS avg_credit_limit
FROM customers
GROUP BY region;

-- 4. Clientes con sus representantes de ventas
SELECT CONCAT(c.customerName) AS cliente,
       CONCAT(e.firstName, ' ', e.lastName) AS representante
FROM customers c
LEFT JOIN employees e
  ON c.salesRepEmployeeNumber = e.employeeNumber;

-- 5. Productos disponibles y en stock
SELECT productCode, productName, quantityInStock
FROM products
WHERE quantityInStock > 0;

-- 6. Productos con precio por debajo del promedio
SELECT productCode, productName, buyPrice
FROM products
WHERE buyPrice < (SELECT AVG(buyPrice) FROM products);

-- 7. Pedidos pendientes por cliente
SELECT o.orderNumber, o.status, c.customerName
FROM orders o
JOIN customers c USING (customerNumber)
WHERE o.status <> 'Shipped';

-- 8. Total de productos por categoría (gama)
SELECT productLine, COUNT(*) AS total_productos
FROM products
GROUP BY productLine;

-- 9. Ingresos totales generados por cliente
SELECT c.customerName, SUM(p.amount) AS total_ingresos
FROM payments p
JOIN customers c USING (customerNumber)
GROUP BY c.customerName;

-- 10. Pedidos realizados en un rango de fechas
-- Cambia '2025-01-01' y '2025-06-30' por las fechas deseadas
SELECT orderNumber, orderDate
FROM orders
WHERE orderDate BETWEEN '2025-01-01' AND '2025-06-30';

-- 11. Detalles de un pedido específico
-- Cambia 10100 por el número de pedido deseado
SELECT od.orderNumber,
       od.productCode,
       od.quantityOrdered,
       (od.quantityOrdered * od.priceEach) AS total_linea
FROM orderdetails od
WHERE od.orderNumber = 10100;

-- 12. Productos más vendidos
SELECT od.productCode,
       p.productName,
       SUM(od.quantityOrdered) AS total_vendido
FROM orderdetails od
JOIN products p USING (productCode)
GROUP BY od.productCode
ORDER BY total_vendido DESC;

-- 13. Pedidos con valor total superior al promedio
WITH pedidos_tot AS (
    SELECT orderNumber,
           SUM(quantityOrdered * priceEach) AS valor_total
    FROM orderdetails
    GROUP BY orderNumber
)
SELECT pt.orderNumber, pt.valor_total
FROM pedidos_tot pt
WHERE pt.valor_total > (SELECT AVG(valor_total) FROM pedidos_tot);

-- 14. Clientes sin representante de ventas asignado
SELECT customerNumber, customerName
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

-- 15. Número total de empleados por oficina
SELECT officeCode, COUNT(*) AS total_empleados
FROM employees
GROUP BY officeCode;

-- 16. Pagos realizados en una forma específica
-- Ejemplo: 'Credit Card'
SELECT *
FROM payments
WHERE paymentMethod = 'Credit Card';

-- 17. Ingresos mensuales
SELECT DATE_FORMAT(paymentDate, '%Y-%m') AS mes,
       SUM(amount) AS ingresos
FROM payments
GROUP BY mes
ORDER BY mes;

-- 18. Clientes con múltiples pedidos
SELECT c.customerName, COUNT(o.orderNumber) AS num_pedidos
FROM customers c
JOIN orders o USING (customerNumber)
GROUP BY c.customerName
HAVING COUNT(o.orderNumber) > 1;

-- 19. Pedidos con productos agotados
SELECT DISTINCT od.orderNumber
FROM orderdetails od
JOIN products p USING (productCode)
WHERE p.quantityInStock = 0;

-- 20. AVG, MAX, MIN del límite de crédito por país
SELECT country,
       AVG(creditLimit) AS avg_cl,
       MAX(creditLimit) AS max_cl,
       MIN(creditLimit) AS min_cl
FROM customers
GROUP BY country;

-- 21. Historial de transacciones de un cliente
-- Cambia 103 por el número de cliente deseado
SELECT paymentDate, amount, paymentMethod
FROM payments
WHERE customerNumber = 103
ORDER BY paymentDate;

-- 22. Empleados sin jefe directo asignado
SELECT employeeNumber, firstName, lastName, managerEmployeeNumber
FROM employees
WHERE managerEmployeeNumber IS NULL;

-- 23. Productos cuyo precio supera el promedio de su gama
SELECT p.productCode, p.productName, p.buyPrice, p.productLine
FROM products p
JOIN (
    SELECT productLine, AVG(buyPrice) AS avg_price
    FROM products
    GROUP BY productLine
) avg_line USING (productLine)
WHERE p.buyPrice > avg_line.avg_price;

-- 24. Promedio de días de entrega por estado
SELECT status,
       AVG(DATEDIFF(shippedDate, orderDate)) AS avg_days_to_ship
FROM orders
WHERE shippedDate IS NOT NULL
GROUP BY status;

-- 25. Clientes por país con más de un pedido
SELECT country, COUNT(DISTINCT c.customerNumber) AS num_clientes
FROM customers c
JOIN orders o USING (customerNumber)
GROUP BY country
HAVING COUNT(o.orderNumber) > 1;
