-- 45. Actualizar la descripción de una promoción en un rango de fechas
UPDATE promotion 
SET name = 'Promoción  especial de Fin de año' 
WHERE date_start >= TO_DATE('2025-10-21', 'YYYY-MM-DD')
  AND date_end <= TO_DATE('2025-11-01', 'YYYY-MM-DD');

-- 46. Modificar la ubicación de un producto en la bodega. Favor proporcionar una ubicación
UPDATE slot
SET shelf_id = 40 
WHERE id = (
    SELECT s.id
    FROM slot s
    JOIN product p ON s.product_id = p.id
    WHERE p.name = 'Manzana Roja 1 kg'
      AND ROWNUM = 1
);

--47. Cambiar el estado de un cliente (activo/inactivo) basado en su actividad en un rango de fechas

UPDATE client
SET status = 'inactive'
WHERE id IN (
    SELECT c.id
    FROM client c
    LEFT JOIN sale s ON c.id = s.client_id
      AND s.transaction_date BETWEEN TO_DATE('2025-06-01','YYYY-MM-DD') AND TO_DATE('2025-10-31','YYYY-MM-DD')
    GROUP BY c.id
    HAVING COUNT(s.id) = 0
);

--Consultas de Eliminación (DELETE)
--49. Eliminar un producto que no se ha vendido en un rango de fechas específico.
DECLARE
    v_id_producto INT;
BEGIN
    SELECT p.id INTO v_id_producto
    FROM product p
    LEFT JOIN sale_detail sd ON p.id = sd.product_id
    GROUP BY p.id
    ORDER BY SUM(sd.quantity) ASC NULLS FIRST
    FETCH FIRST 1 ROW ONLY;

    -- Eliminar referencias en tablas hijas
    DELETE FROM slot WHERE product_id = v_id_producto;
    DELETE FROM sale_detail WHERE product_id = v_id_producto;
    DELETE FROM purchase_detail WHERE product_id = v_id_producto;
    DELETE FROM inventory_detail WHERE product_id = v_id_producto;
    DELETE FROM promotion_product WHERE product_id = v_id_producto;
    DELETE FROM supplier_product WHERE product_id = v_id_producto;
    -- Finalmente eliminar el producto
    DELETE FROM product WHERE id = v_id_producto;

    COMMIT;
END;

--50. Eliminar un cliente que ha estado inactivo durante un período determinado. Eliminar el cliente que no ha tenido movimiento en el año 2023

DECLARE
    v_id_cliente INT;
BEGIN
    -- Buscar cliente inactivo sin ventas en 2023
    SELECT c.id INTO v_id_cliente
    FROM client c
    WHERE c.status = 'inactive'
      AND c.id NOT IN (
          SELECT DISTINCT s.client_id
          FROM sale s
          WHERE EXTRACT(YEAR FROM s.transaction_date) = 2023
      )
    FETCH FIRST 1 ROW ONLY;

    -- Eliminar detalles de ventas
    DELETE FROM sale_detail WHERE sale_id IN (SELECT id FROM sale WHERE client_id = v_id_cliente);

    -- Eliminar ventas
    DELETE FROM sale WHERE client_id = v_id_cliente;

    -- Eliminar cliente
    DELETE FROM client WHERE id = v_id_cliente;

    COMMIT;
END;
/

--51. Eliminar un proveedor que no ha tenido ventas en un rango de fechas específico, y no
--ha entregado ningún producto de por mal estado (analizar las devoluciones).
UPDATE supplier
SET status = 'inactive'
WHERE id = (
    SELECT s.id
    FROM supplier s
    LEFT JOIN purchase p ON s.id = p.supplier_id
    GROUP BY s.id
    ORDER BY COUNT(p.id) ASC
    FETCH FIRST 1 ROW ONLY
);

DECLARE
    v_id_supplier INT;
BEGIN
    -- Obtener el proveedor inactivo
    SELECT id INTO v_id_supplier
    FROM supplier
    WHERE status = 'inactive'
    FETCH FIRST 1 ROW ONLY;
    -- Eliminar detalles de compras
    DELETE FROM purchase_detail WHERE purchase_id IN (SELECT id FROM purchase WHERE supplier_id = v_id_supplier);
    -- Eliminar compras
    DELETE FROM purchase WHERE supplier_id = v_id_supplier;
    -- Eliminar relación con productos
    DELETE FROM supplier_product WHERE supplier_id = v_id_supplier;
    --eliminar el proveedor
    DELETE FROM supplier WHERE id = v_id_supplier;
    COMMIT;
END;
/

--52. Agregue las tuplas con insert de los municipios: 

INSERT INTO department (name) VALUES ('Chalatenango');
SELECT id FROM department WHERE name = 'Chalatenango';
-- Chalatenango Norte
INSERT INTO municipality (name, department_id) VALUES ('Citalá', 23);
INSERT INTO municipality (name, department_id) VALUES ('La Palma', 23);
INSERT INTO municipality (name, department_id) VALUES ('San Ignacio', 23);
-- Chalatenango Centro
INSERT INTO municipality (name, department_id) VALUES ('Agua Caliente', 23);
INSERT INTO municipality (name, department_id) VALUES ('Dulce Nombre de María', 23);
INSERT INTO municipality (name, department_id) VALUES ('El Paraíso', 23);
INSERT INTO municipality (name, department_id) VALUES ('La Reina', 23);
INSERT INTO municipality (name, department_id) VALUES ('Nueva Concepción', 23);
INSERT INTO municipality (name, department_id) VALUES ('San Fernando', 23);
INSERT INTO municipality (name, department_id) VALUES ('San Francisco Morazán', 23);
INSERT INTO municipality (name, department_id) VALUES ('San Rafael', 23);
INSERT INTO municipality (name, department_id) VALUES ('Santa Rita', 23);
INSERT INTO municipality (name, department_id) VALUES ('Tejutla', 23);


INSERT INTO sale (sale_type, document, sequence, total, transaction_date, transaction_user, store_id, employee_id, client_id)
VALUES ('sale', 'FACT-CHAL-001', 'SEQ-CHAL-001', 350.00, SYSDATE, 'system', 1, 10, 5);

INSERT INTO sale (sale_type, document, sequence, total, transaction_date, transaction_user, store_id, employee_id, client_id)
VALUES ('sale', 'FACT-CHAL-002', 'SEQ-CHAL-002', 420.00, SYSDATE, 'system', 2, 15, 8);

DELETE FROM municipality WHERE department_id = 23;

--53. Eliminar un registro de inventario que no es relevante en un rango de fechas. Es
--importante indicar que no es relevante cuando no ha tenido movimientos 

UPDATE inventory_detail
SET quantity_start = 0,
    quantity_end = 0,
    quantity_current = 0,
    price_start = 0,
    price_end = 0,
    price_current = 0
WHERE inventory_id = 1;

DELETE FROM inventory_detail
WHERE inventory_id = (
    SELECT id FROM (
        SELECT i.id
        FROM inventory i
        LEFT JOIN inventory_detail d ON d.inventory_id = i.id
        WHERE i.date_start BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
                               AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
        GROUP BY i.id, i.date_start
        ORDER BY NVL(SUM(d.quantity_current), 0) ASC, i.date_start ASC
        FETCH FIRST 1 ROW ONLY
    )
);
DELETE FROM inventory
WHERE id = (
    SELECT id FROM (
        SELECT i.id
        FROM inventory i
        LEFT JOIN inventory_detail d ON d.inventory_id = i.id
        WHERE i.date_start BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
                               AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
        GROUP BY i.id, i.date_start
        ORDER BY NVL(SUM(d.quantity_current), 0) ASC, i.date_start ASC
        FETCH FIRST 1 ROW ONLY
    )
);

--54. Eliminar productos que han sido descontinuados, es decir tienen fecha del año 2005
ALTER TABLE product ADD discontinued_date DATE;

UPDATE product
SET discontinued_date = TO_DATE('2005-06-15', 'YYYY-MM-DD')
WHERE id IN (1);


DELETE FROM slot WHERE product_id IN (
    SELECT id FROM product WHERE EXTRACT(YEAR FROM discontinued_date) = 2005
);
DELETE FROM sale_detail WHERE product_id IN (
    SELECT id FROM product WHERE EXTRACT(YEAR FROM discontinued_date) = 2005
);
DELETE FROM purchase_detail WHERE product_id IN (
    SELECT id FROM product WHERE EXTRACT(YEAR FROM discontinued_date) = 2005
);
DELETE FROM supplier_product WHERE product_id IN (
    SELECT id FROM product WHERE EXTRACT(YEAR FROM discontinued_date) = 2005
);
DELETE FROM promotion_product WHERE product_id IN (
    SELECT id FROM product WHERE EXTRACT(YEAR FROM discontinued_date) = 2005
);
DELETE FROM inventory_detail
WHERE product_id IN (
    SELECT id FROM product WHERE EXTRACT(YEAR FROM discontinued_date) = 2005
);
DELETE FROM product
WHERE EXTRACT(YEAR FROM discontinued_date) = 2005;

--Consultas de Agregación y Análisis
--55. Calcular el total de ventas por categoría de producto en un rango de fechas

SELECT pt.name AS categoria,
       SUM(sd.quantity * sd.price) AS total_ventas
FROM sale s
JOIN sale_detail sd ON s.id = sd.sale_id
JOIN product p ON sd.product_id = p.id
JOIN product_type pt ON p.product_type_id = pt.id
WHERE s.transaction_date BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD')
                             AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
GROUP BY pt.name
ORDER BY total_ventas DESC;

--56. Calcular por producto por tienda, el listado de productos que cumplan las siguientes
--Mínimo, máximo, promedio de ventas, cantidad de ventas todo esto por productos de la
--tienda 01

SELECT p.name AS producto,
       MIN(sd.price) AS precio_minimo,
       MAX(sd.price) AS precio_maximo,
       ROUND(AVG(sd.price), 2) AS precio_promedio,
       SUM(sd.quantity) AS cantidad_total,
       COUNT(sd.sale_id) AS cantidad_ventas
FROM sale s
JOIN sale_detail sd ON s.id = sd.sale_id
JOIN product p ON sd.product_id = p.id
WHERE s.store_id = 1
GROUP BY p.name
ORDER BY cantidad_total DESC;

-- 57. Obtener el promedio de ventas por cliente en un rango de fechas específico. Para esto
--es el del cliente Marco Antonio García 

SELECT c.first_name || ' ' || c.last_name AS cliente,
       ROUND(AVG(s.total), 2) AS promedio_ventas
FROM sale s
JOIN client c ON s.client_id = c.id
WHERE c.first_name = 'Violeta'
  AND c.last_name LIKE 'Soto Hernández%'
  AND s.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD')
                              AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
GROUP BY c.first_name, c.last_name;

-- 58. Calcular la cantidad de productos vendidos por categoría en un rango de fechas.

SELECT pt.name AS categoria,
       SUM(sd.quantity) AS cantidad_vendida
FROM sale s
JOIN sale_detail sd ON s.id = sd.sale_id
JOIN product p ON sd.product_id = p.id
JOIN product_type pt ON p.product_type_id = pt.id
WHERE s.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD')
                              AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
GROUP BY pt.name
ORDER BY cantidad_vendida DESC;

--59. Consultar cuál es el producto más vendido en un rango de fechas.

SELECT producto, cantidad_vendida
FROM (
    SELECT p.name AS producto,
           SUM(sd.quantity) AS cantidad_vendida
    FROM sale s
    JOIN sale_detail sd ON s.id = sd.sale_id
    JOIN product p ON sd.product_id = p.id
    WHERE s.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD')
                                  AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
    GROUP BY p.name
    ORDER BY cantidad_vendida DESC
)
WHERE ROWNUM = 1;

-- 60. Identificar los productos que han tenido un aumento de precio en un rango de fechas.,
--tomar en consideración las ventas y sus productos que han sido recurrentes con
--aumento de precios

UPDATE sale_detail
SET price = CASE
              WHEN ROWNUM <= 2 THEN price * 1.10  -- aumenta 10% en dos registros
              ELSE price
            END
WHERE product_id = 2;


SELECT producto,
       MIN(precio) AS precio_minimo,
       MAX(precio) AS precio_maximo,
       ROUND(((MAX(precio) - MIN(precio)) / MIN(precio)) * 100, 2) AS porcentaje_aumento,
       COUNT(*) AS veces_vendido
FROM (
    SELECT p.name AS producto,
           sd.price AS precio
    FROM sale s
    JOIN sale_detail sd ON s.id = sd.sale_id
    JOIN product p ON sd.product_id = p.id
    WHERE s.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD')
                                  AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
)
GROUP BY producto
HAVING MAX(precio) > MIN(precio)
   AND COUNT(*) > 1
ORDER BY porcentaje_aumento DESC;

-- 61. Consultar las ventas realizadas por hora en un día específico.
SELECT TO_CHAR(s.transaction_date, 'HH24') AS hora,
       COUNT(*) AS cantidad_ventas,
       SUM(s.total) AS total_ventas
FROM sale s
WHERE TRUNC(s.transaction_date) = TO_DATE('2024-12-01', 'YYYY-MM-DD') -- Día específico
GROUP BY TO_CHAR(s.transaction_date, 'HH24')
ORDER BY hora;

--62. Contar el número total de devoluciones por mes en un rango de fechas, del producto 0100

INSERT INTO sale_detail (line, sale_id, product_id, quantity, price, transaction_date, transaction_user)
VALUES (1,653, 2,  10, 15.00,TO_DATE('15/06/2025', 'DD/MM/YYYY'), 'admin');
SELECT
    TO_CHAR(s.transaction_date, 'YYYY-MM') AS anio_mes,
    SUM(sd.quantity) AS total_unidades_devueltas
FROM sale s
JOIN sale_detail sd ON s.id = sd.sale_id
WHERE s.sale_type = 'return'
AND sd.product_id = 2
AND s.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
GROUP BY TO_CHAR(s.transaction_date, 'YYYY-MM')
ORDER BY anio_mes;

--63. Calcular el total de ventas realizadas por día en un rango de fechas.

SELECT
    TRUNC(s.transaction_date) AS fecha_dia,
    SUM(s.total) AS total_ventas
FROM sale s
WHERE s.sale_type = 'sale'
-- Rango de ejemplo (todo el año 2025)
AND s.transaction_date >= TO_DATE('2025-01-01', 'YYYY-MM-DD')
AND s.transaction_date < TO_DATE('2026-01-01', 'YYYY-MM-DD')
GROUP BY TRUNC(s.transaction_date)
ORDER BY fecha_dia;

-- 64. Obtener el total de ingresos generados por cada tienda en un rango de fechas
SELECT
    st.name AS tienda,
    SUM(s.total) AS total_ingresos
FROM sale s
JOIN store st ON s.store_id = st.id
WHERE s.sale_type = 'sale'
-- Rango de ejemplo (todo el año 2025)
AND s.transaction_date >= TO_DATE('2025-01-01', 'YYYY-MM-DD')
AND s.transaction_date < TO_DATE('2026-01-01', 'YYYY-MM-DD')
GROUP BY st.id, st.name
ORDER BY total_ingresos DESC;

-- 65. Contar la cantidad de clientes que han realizado más de 5 compras en un rango de fechas del año 2025.
WITH ConteoPorCliente AS (
    SELECT
        client_id,
        COUNT(id) AS numero_compras
    FROM sale
    WHERE sale_type = 'sale'
    AND transaction_date >= TO_DATE('2025-01-01', 'YYYY-MM-DD')
    AND transaction_date < TO_DATE('2026-01-01', 'YYYY-MM-DD')
    GROUP BY client_id
)
SELECT
    COUNT(*) AS total_clientes_con_mas_de_5_compras
FROM ConteoPorCliente
WHERE numero_compras > 5;

--66. Calcular el total de ventas por proveedor en un rango de fechas específico.
SELECT
    sup.company_name AS proveedor,
    SUM(sd.quantity * sd.price) AS total_generado_por_ventas
FROM sale s
JOIN sale_detail sd ON s.id = sd.sale_id
JOIN supplier_product sp ON sd.product_id = sp.product_id
JOIN supplier sup ON sp.supplier_id = sup.id
WHERE
    s.sale_type = 'sale'
AND s.transaction_date >= TO_DATE('2025-01-01', 'YYYY-MM-DD')
AND s.transaction_date < TO_DATE('2026-01-01', 'YYYY-MM-DD')
GROUP BY
    sup.id, sup.company_name
ORDER BY
    total_generado_por_ventas DESC;