-- ============================================================================
-- CONSULTA 1: Inventario por tienda, agrupado y ordenado por categoría
-- ============================================================================
SELECT 
    s.id AS tienda_id,
    s.name AS nombre_tienda,
    pt.name AS clase_producto,
    p.name AS producto,
    id_detail.quantity_current AS cantidad_disponible,
    id_detail.price_current AS precio_actual
FROM inventory i
INNER JOIN store s ON i.store_id = s.id
INNER JOIN inventory_detail id_detail ON i.id = id_detail.inventory_id
INNER JOIN product p ON id_detail.product_id = p.id
INNER JOIN product_type pt ON p.product_type_id = pt.id
WHERE i.status = 'active'
ORDER BY s.name, pt.name, p.name;


-- ============================================================================
-- CONSULTA 2: Productos de categoría Juguetes (con UPPER)
-- ============================================================================

SELECT 
    p.id AS producto_id,
    p.name AS nombre_producto,
    pt.name AS categoria
FROM product p
INNER JOIN product_type pt ON p.product_type_id = pt.id
WHERE UPPER(pt.name) = UPPER('Juguetes');


-- ============================================================================
-- CONSULTA 3: Búsqueda de carros TONKA usando comodines
-- ============================================================================
SELECT 
    p.id AS producto_id,
    p.name AS nombre_producto,
    pt.name AS categoria
FROM product p
INNER JOIN product_type pt ON p.product_type_id = pt.id
WHERE UPPER(p.name) LIKE UPPER('%TONKA%')
   OR UPPER(p.name) LIKE UPPER('%carro%')
ORDER BY p.name;


-- ============================================================================
-- CONSULTA 4: Productos de categoría Juguetes (repetida con UPPER)
-- ============================================================================
SELECT 
    p.id AS producto_id,
    p.name AS nombre_producto,
    pt.id AS categoria_id,
    pt.name AS categoria
FROM product p
INNER JOIN product_type pt ON p.product_type_id = pt.id
WHERE UPPER(pt.name) = 'JUGUETES';


-- ============================================================================
-- CONSULTA 5: Productos dentro de un dominio de códigos específicos
-- ============================================================================
SELECT 
    p.id AS producto_id,
    p.name AS nombre_producto,
    pt.name AS categoria
FROM product p
INNER JOIN product_type pt ON p.product_type_id = pt.id
WHERE p.id IN (1, 2, 3, 50, 99, 105)
ORDER BY p.id;


-- ============================================================================
-- CONSULTA 6: Clientes con edad calculada (años, meses, días)
-- ============================================================================

SELECT 
    id AS id_cliente,
    first_name AS nombre,
    last_name AS apellido,
    birthday AS fecha_nacimiento,
    FLOOR(MONTHS_BETWEEN(SYSDATE, birthday) / 12) AS anios_edad,
    MOD(FLOOR(MONTHS_BETWEEN(SYSDATE, birthday)), 12) AS meses_edad,
    FLOOR(SYSDATE - ADD_MONTHS(birthday, 
        FLOOR(MONTHS_BETWEEN(SYSDATE, birthday)))) AS dias_mes_calendario
FROM client
ORDER BY id;


-- ============================================================================
-- CONSULTA 7: Inventario de tienda específica en Guatemala
-- ============================================================================

SELECT 
    s.id AS tienda_id,
    s.name AS nombre_tienda,
    s.address AS direccion,
    m.name AS municipio,
    d.name AS departamento,
    p.name AS producto,
    pt.name AS categoria,
    id_detail.quantity_current AS cantidad
FROM inventory i
INNER JOIN store s ON i.store_id = s.id
INNER JOIN municipality m ON s.municipality_id = m.id
INNER JOIN department d ON m.department_id = d.id
INNER JOIN inventory_detail id_detail ON i.id = id_detail.inventory_id
INNER JOIN product p ON id_detail.product_id = p.id
INNER JOIN product_type pt ON p.product_type_id = pt.id
WHERE UPPER(d.name) = UPPER('Guatemala')
  AND UPPER(m.name) = UPPER('Guatemala')
  AND (UPPER(s.name) LIKE UPPER('%La Torre Naranjo%') 
       OR UPPER(s.name) LIKE UPPER('%El Naranjo%'))
  AND i.status = 'active';


-- ============================================================================
-- CONSULTA 8: Cantidad de tiendas por departamento y municipio
-- ============================================================================
SELECT 
    d.name AS departamento,
    m.name AS municipio,
    COUNT(s.id) AS cantidad_tiendas
FROM department d
INNER JOIN municipality m ON d.id = m.department_id
LEFT JOIN store s ON m.id = s.municipality_id
GROUP BY d.name, m.name
ORDER BY d.name, m.name;


-- ============================================================================
-- CONSULTA 9: Ventas totales del año 2025
-- ============================================================================
SELECT 
    s.id AS tienda_id,
    s.name AS nombre_tienda,
    sa.transaction_date AS fecha,
    sa.sale_type AS tipo_venta,
    sa.total AS monto_total,
    sd.product_id AS producto_id,
    p.name AS nombre_producto,
    sd.quantity AS cantidad,
    sd.price AS precio,
    (sd.quantity * sd.price) AS precio_cantidad
FROM sale sa
INNER JOIN store s ON sa.store_id = s.id
INNER JOIN sale_detail sd ON sa.id = sd.sale_id
INNER JOIN product p ON sd.product_id = p.id
WHERE EXTRACT(YEAR FROM sa.transaction_date) = 2025
ORDER BY sa.transaction_date, s.name;


-- ============================================================================
-- CONSULTA 10: Historial de compras de un cliente en rango de fechas
-- ============================================================================

SELECT 
    c.id AS cliente_id,
    c.first_name || ' ' || c.last_name AS nombre_cliente,
    sa.id AS factura_id,
    sa.document AS numero_documento,
    sa.transaction_date AS fecha_compra,
    sa.total AS total_factura,
    p.name AS producto,
    sd.quantity AS cantidad,
    sd.price AS precio_unitario,
    (sd.quantity * sd.price) AS subtotal
FROM client c
INNER JOIN sale sa ON c.id = sa.client_id
INNER JOIN sale_detail sd ON sa.id = sd.sale_id
INNER JOIN product p ON sd.product_id = p.id
WHERE c.id = 1  -- Cambiar por el ID del cliente específico
  AND sa.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
                               AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
ORDER BY sa.transaction_date, sa.id, sd.line;


-- ============================================================================
-- CONSULTA 11: Productos con bajo stock (menos de 10 unidades)
-- ============================================================================

SELECT 
    pt.name AS clase_producto,
    p.name AS nombre_producto,
    s.name AS tienda,
    id_detail.quantity_current AS cantidad_actual
FROM inventory_detail id_detail
INNER JOIN product p ON id_detail.product_id = p.id
INNER JOIN product_type pt ON p.product_type_id = pt.id
INNER JOIN inventory i ON id_detail.inventory_id = i.id
INNER JOIN store s ON i.store_id = s.id
WHERE id_detail.quantity_current < 10
  AND i.status = 'active'
ORDER BY pt.name DESC, p.name ASC;


-- ============================================================================
-- CONSULTA 12: Proveedores de un producto específico (Detergente FAB en Polvo)
-- ============================================================================
SELECT 
    sup.id AS proveedor_id,
    sup.company_name AS nombre_proveedor,
    sup.address AS direccion,
    p.name AS producto,
    sp.price AS precio_proveedor
FROM supplier sup
INNER JOIN supplier_product sp ON sup.id = sp.supplier_id
INNER JOIN product p ON sp.product_id = p.id
WHERE UPPER(p.name) LIKE UPPER('%FAB%')
  AND UPPER(p.name) LIKE UPPER('%Polvo%')
  AND sup.status = 'active'
ORDER BY sp.price;


-- ============================================================================
-- CONSULTA 13: Ventas por mes en rango de años (usando INNER JOIN)
-- ============================================================================

SELECT 
    TO_CHAR(sa.transaction_date, 'YYYY-MM') AS mes_anio,
    COUNT(sa.id) AS cantidad_ventas,
    SUM(sa.total) AS total_ventas,
    c.first_name || ' ' || c.last_name AS cliente,
    d.name AS departamento,
    m.name AS municipio
FROM sale sa
INNER JOIN client c ON sa.client_id = c.id
INNER JOIN department d ON c.department_id = d.id
INNER JOIN store s ON sa.store_id = s.id
INNER JOIN municipality m ON s.municipality_id = m.id
WHERE UPPER(d.name) = UPPER('Guatemala')
  AND UPPER(m.name) = UPPER('San Miguel Petapa')
  AND EXTRACT(YEAR FROM sa.transaction_date) BETWEEN 2024 AND 2025
GROUP BY TO_CHAR(sa.transaction_date, 'YYYY-MM'), 
         c.first_name, c.last_name, d.name, m.name
ORDER BY mes_anio;


-- ============================================================================
-- CONSULTA 14: Ventas por mes (usando JOIN IMPLÍCITO)
-- ============================================================================
SELECT 
    TO_CHAR(sa.transaction_date, 'YYYY-MM') AS mes_anio,
    COUNT(sa.id) AS cantidad_ventas,
    SUM(sa.total) AS total_ventas,
    c.first_name || ' ' || c.last_name AS cliente,
    d.name AS departamento,
    m.name AS municipio
FROM sale sa, client c, department d, store s, municipality m
WHERE sa.client_id = c.id
  AND c.department_id = d.id
  AND sa.store_id = s.id
  AND s.municipality_id = m.id
  AND UPPER(d.name) = UPPER('Guatemala')
  AND UPPER(m.name) = UPPER('San Miguel Petapa')
  AND EXTRACT(YEAR FROM sa.transaction_date) BETWEEN 2024 AND 2025
GROUP BY TO_CHAR(sa.transaction_date, 'YYYY-MM'), 
         c.first_name, c.last_name, d.name, m.name
ORDER BY mes_anio;


-- ============================================================================
-- CONSULTA 15: Clientes registrados en el último mes
-- ============================================================================

SELECT 
    COUNT(*) AS clientes_ultimo_mes
FROM client
WHERE birthday >= ADD_MONTHS(SYSDATE, -1);

-- ============================================================================
-- CONSULTA 16: Top 5 ventas más altas en rango de fechas
-- ============================================================================
SELECT * FROM (
    SELECT 
        c.id AS cliente_id,
        c.first_name || ' ' || c.last_name AS nombre_cliente,
        sa.id AS factura_id,
        sa.document AS numero_factura,
        sa.transaction_date AS fecha,
        sa.total AS total_venta
    FROM sale sa
    INNER JOIN client c ON sa.client_id = c.id
    WHERE sa.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
                                   AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
    ORDER BY sa.total DESC
)
WHERE ROWNUM <= 5;

-- ============================================================================
-- CONSULTA 17: Productos vendidos en rango de fechas (con INNER JOIN)
-- ============================================================================
SELECT 
    p.id AS producto_id,
    p.name AS nombre_producto,
    pt.name AS categoria,
    SUM(sd.quantity) AS cantidad_total_vendida,
    SUM(sd.quantity * sd.price) AS total_ingresos
FROM sale_detail sd
INNER JOIN sale sa ON sd.sale_id = sa.id
INNER JOIN product p ON sd.product_id = p.id
INNER JOIN product_type pt ON p.product_type_id = pt.id
WHERE sa.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
                               AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
GROUP BY p.id, p.name, pt.name
ORDER BY cantidad_total_vendida DESC;


-- ============================================================================
-- CONSULTA 18: Productos vendidos en rango de fechas (usando NOT EXISTS)
-- ============================================================================
SELECT 
    p.id AS producto_id,
    p.name AS nombre_producto,
    pt.name AS categoria
FROM product p
INNER JOIN product_type pt ON p.product_type_id = pt.id
WHERE NOT EXISTS (
    SELECT 1 
    FROM sale_detail sd
    INNER JOIN sale sa ON sd.sale_id = sa.id
    WHERE sd.product_id = p.id
      AND sa.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
                                   AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
)
ORDER BY p.name;

-- ============================================================================
-- CONSULTA 19: Total de ventas por tienda en mes y año específicos
-- ============================================================================
DEFINE mes = 9
DEFINE anio = 2025

SELECT 
    s.name AS nombre_tienda,
    COUNT(sa.id) AS cantidad_ventas,
    SUM(sa.total) AS total_ventas
FROM sale sa
INNER JOIN store s ON sa.store_id = s.id
WHERE EXTRACT(MONTH FROM sa.transaction_date) = &mes
  AND EXTRACT(YEAR FROM sa.transaction_date) = &anio
  AND s.id IN (SELECT id FROM store)  -- Solo tiendas activas
GROUP BY s.name
ORDER BY total_ventas DESC;

-- ============================================================================
-- CONSULTA 20: Clientes con compras en rango de fechas (monto mínimo)
-- ============================================================================
DEFINE fechaInicio = '2025-01-01'
DEFINE fechaFin = '2025-06-30'
DEFINE montoMinimo = 100

SELECT 
    COUNT(DISTINCT c.id) AS cantidad_clientes,
    SUM(total_compras) AS total_general
FROM (
    SELECT 
        c.id,
        c.first_name || ' ' || c.last_name AS nombre_cliente,
        SUM(sa.total) AS total_compras
    FROM client c
    INNER JOIN sale sa ON c.id = sa.client_id
    WHERE sa.transaction_date BETWEEN TO_DATE('&fechaInicio', 'YYYY-MM-DD') 
                                   AND TO_DATE('&fechaFin', 'YYYY-MM-DD')
    GROUP BY c.id, c.first_name, c.last_name
    HAVING SUM(sa.total) > &montoMinimo
) subquery;

-- ============================================================================
-- CONSULTA 21: Productos comprados más de 10 veces
-- ============================================================================
DEFINE fechaInicio = '2025-01-01'
DEFINE fechaFin = '2025-03-31'

SELECT 
    p.name AS nombre_producto,
    COUNT(sd.id) AS cantidad_compras,
    SUM(sd.quantity) AS cantidad_total_vendida
FROM sale_detail sd
INNER JOIN sale sa ON sd.sale_id = sa.id
INNER JOIN product p ON sd.product_id = p.id
WHERE sa.transaction_date BETWEEN TO_DATE('&fechaInicio', 'YYYY-MM-DD') 
                               AND TO_DATE('&fechaFin', 'YYYY-MM-DD')
GROUP BY p.id, p.name
HAVING COUNT(sd.id) > 10
ORDER BY cantidad_compras DESC;

-- Versión sin variables:
/*
SELECT 
    p.name AS nombre_producto,
    COUNT(sd.id) AS cantidad_compras,
    SUM(sd.quantity) AS cantidad_total_vendida
FROM sale_detail sd
INNER JOIN sale sa ON sd.sale_id = sa.id
INNER JOIN product p ON sd.product_id = p.id
WHERE sa.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
                               AND TO_DATE('2025-03-31', 'YYYY-MM-DD')
GROUP BY p.id, p.name
HAVING COUNT(sd.id) > 10
ORDER BY cantidad_compras DESC;
*/


-- ============================================================================
-- CONSULTA 22: Promedio de ventas diarias en rango de fechas
-- ============================================================================
DEFINE fechaInicio = '2025-04-01'
DEFINE fechaFin = '2025-04-30'

SELECT 
    AVG(total_dia) AS promedio_ventas_diarias
FROM (
    SELECT 
        TRUNC(sa.transaction_date) AS fecha,
        SUM(sa.total) AS total_dia
    FROM sale sa
    WHERE sa.transaction_date BETWEEN TO_DATE('&fechaInicio', 'YYYY-MM-DD') 
                                   AND TO_DATE('&fechaFin', 'YYYY-MM-DD')
    GROUP BY TRUNC(sa.transaction_date)
);