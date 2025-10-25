-- Consulta 23 (devoluciones de productos) --
SELECT 
    p.name AS producto,
    s.transaction_date AS fecha_devolucion,
    s.document AS motivo
FROM 
    sale s
JOIN 
    sale_detail sd ON s.id = sd.sale_id
JOIN 
    product p ON sd.product_id = p.id
WHERE 
    s.sale_type = 'return'
    AND s.transaction_date 
    BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
    AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
    AND (
        LOWER(s.document) LIKE '%defecto%'
        OR LOWER(s.document) LIKE '%equivocación%'
    )
ORDER BY 
    s.transaction_date;

-- Consulta 24 (total de ingresos generados por cada tienda) --
SELECT 
    s.store_id AS tienda,
    SUM(sd.quantity * sd.price) AS total_ingresos
FROM 
    sale s
JOIN 
    sale_detail sd 
    ON s.id = sd.sale_id
WHERE 
    s.sale_type = 'sale'
    AND s.transaction_date 
    BETWEEN DATE '2025-01-01' 
    AND DATE '2025-12-31'
GROUP BY 
    s.store_id
ORDER BY 
    total_ingresos DESC;

-- Consulta 25 (compras realizadas por un cliente específico) --
SELECT 
    s.id AS numero_venta,
    s.sequence AS secuencia,
    s.transaction_date AS fecha,
    s.total,
    s.sale_type AS tipo_venta,
    s.document AS documento
FROM sale s
WHERE s.client_id = 99
    AND EXTRACT(MONTH FROM s.transaction_date) = 4
    AND EXTRACT(YEAR FROM s.transaction_date) = 2025
ORDER BY s.transaction_date DESC;

-- consulta 26 (productos que no se han vendido) --
SELECT 
    p.id AS producto_id,
    p.name AS nombre_producto,
    pt.name AS tipo_producto,
    id_detail.quantity_current AS cantidad_disponible,
    id_detail.price_current AS precio_actual,
    (id_detail.quantity_current * id_detail.price_current) AS valor_inventario,
    i.store_id AS tienda_id,
    i.date_start AS fecha_inicio_inventario,
    i.date_end AS fecha_fin_inventario
FROM product p
INNER JOIN product_type pt ON p.product_type_id = pt.id
INNER JOIN inventory_detail id_detail ON p.id = id_detail.product_id
INNER JOIN inventory i ON id_detail.inventory_id = i.id
WHERE i.status = 'active'
    AND id_detail.quantity_current > 0
    AND NOT EXISTS (
        SELECT 1
        FROM sale_detail sd
        INNER JOIN sale s ON sd.sale_id = s.id
        WHERE sd.product_id = p.id
            AND s.transaction_date 
            BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
            AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
    )
ORDER BY i.store_id, pt.name, p.name;

-- Consulta 27 (total de devoluciones) --
SELECT 
    COUNT(DISTINCT s.id) AS total_devoluciones,
    COUNT(sd.id) AS total_items_devueltos,
    SUM(sd.quantity) AS cantidad_total_devuelta,
    SUM(sd.quantity * sd.price) AS monto_total_devoluciones
FROM sale s
JOIN sale_detail sd ON s.id = sd.sale_id
JOIN store st ON s.store_id = st.id
JOIN municipality m ON st.municipality_id = m.id
JOIN department d ON m.department_id = d.id
WHERE s.sale_type = 'return'
    AND s.transaction_date BETWEEN TO_DATE('2025-02-01', 'YYYY-MM-DD') 
    AND TO_DATE('2025-02-28', 'YYYY-MM-DD')
    AND LOWER(s.document) NOT LIKE '%daño menor%'
    AND LOWER(st.name) LIKE '%la torre%'
    AND LOWER(d.name) LIKE '%guatemala%'
    AND LOWER(m.name) LIKE '%mixco%'
    AND LOWER(st.address) LIKE '%zona 1%';

-- Consulta 28 (promociones activas) --
SELECT 
    p.id AS producto_id,
    p.name AS producto,
    pt.name AS tipo_producto,
    pr.name AS nombre_promocion,
    pr.date_start AS fecha_inicio_promocion,
    pr.date_end AS fecha_fin_promocion,
    st.name AS tienda
FROM product p
JOIN promotion_product pp ON p.id = pp.product_id
JOIN promotion pr ON pp.promotion_id = pr.id
LEFT JOIN product_type pt ON p.product_type_id = pt.id
JOIN store st ON pr.store_id = st.id
WHERE pr.status = 'active'
    AND pr.date_start >= TO_DATE('2025-10-01', 'YYYY-MM-DD')
    AND pr.date_end <= TO_DATE('2025-10-31', 'YYYY-MM-DD')
ORDER BY p.name;

-- Consulta 29 (ubicación física (pasillo, estantería y casilla)) --
SELECT 
    p.id AS producto_id,
    p.name AS producto,
    pt.name AS tipo_producto,
    st.name AS tienda,
    a.name AS pasillo,
    sh.description AS estanteria,
    sl.description AS casilla,
    sl.price AS precio
FROM product p
JOIN slot sl ON p.id = sl.product_id
JOIN shelf sh ON sl.shelf_id = sh.id
JOIN aisle a ON sh.aisle_id = a.id
JOIN store st ON a.store_id = st.id
LEFT JOIN product_type pt ON p.product_type_id = pt.id
WHERE st.name = 'Tienda Guatemala'
ORDER BY a.name, sh.description;

-- consulta 30 (productos que tienen promociones activas y su ubicación dentro de la bodega) --
SELECT 
    pr.date_start AS fecha_inicio_promocion, 
    pr.date_end AS fecha_fin_promocion,
    pr.name AS promocion,
    pr.status AS estado_promocion,
    COUNT(pp.product_id) AS total_productos
FROM promotion pr
JOIN promotion_product pp ON pr.id = pp.promotion_id
WHERE pr.status = 'active'
GROUP BY pr.date_start, pr.date_end, pr.name, pr.status
ORDER BY pr.date_start;

-- consulta 31 (productos más vendidos durante el último trimestre) --
SELECT 
    p.id AS producto_id,
    p.name AS producto,
    pt.name AS tipo_producto,
    COUNT(sd.id) AS total_ventas,
    SUM(sd.quantity) AS cantidad_total_vendida,
    SUM(sd.quantity * sd.price) AS monto_total_ventas
FROM product p
JOIN sale_detail sd ON p.id = sd.product_id
JOIN sale s ON sd.sale_id = s.id
LEFT JOIN product_type pt ON p.product_type_id = pt.id
WHERE s.sale_type = 'sale'
    AND s.transaction_date BETWEEN TO_DATE('2025-07-01', 'YYYY-MM-DD') 
    AND TO_DATE('2025-09-30', 'YYYY-MM-DD')
    AND NOT EXISTS (
    SELECT 1
    FROM sale_detail sd2
    JOIN sale s2 ON sd2.sale_id = s2.id
    WHERE sd2.product_id = p.id
        AND s2.sale_type = 'return'
        AND s2.transaction_date BETWEEN TO_DATE('2025-07-01', 'YYYY-MM-DD') 
        AND TO_DATE('2025-09-30', 'YYYY-MM-DD')
    )
GROUP BY p.id, p.name, pt.name
HAVING COUNT(sd.id) > 50
ORDER BY total_ventas DESC;

-- conuslta 32 (devoluciones en su totalidad no más de 20 productos) --
SELECT 
    s.id AS devolucion_id,
    s.document AS documento,
    s.sequence AS secuencia,
    s.transaction_date AS fecha_devolucion,
    s.total AS monto_total,
    st.name AS tienda,
    c.first_name || ' ' || c.last_name AS cliente,
    COUNT(sd.id) AS total_items,
    SUM(sd.quantity) AS cantidad_total_devuelta
FROM sale s
JOIN sale_detail sd ON s.id = sd.sale_id
JOIN store st ON s.store_id = st.id
JOIN client c ON s.client_id = c.id
WHERE s.sale_type = 'return'
GROUP BY s.id, s.document, s.sequence, s.transaction_date, s.total, st.name, c.first_name, c.last_name
HAVING SUM(sd.quantity) <= 20
ORDER BY s.transaction_date DESC;

-- consulta 33 (productos vendidos en promoción en un rango de fechas) --
SELECT 
    COUNT(DISTINCT s.id) AS total_ventas_con_promocion,
    COUNT(sd.id) AS total_items_vendidos,
    SUM(sd.quantity) AS cantidad_total_vendida,
    SUM(sd.quantity * sd.price) AS monto_total_ventas
FROM sale s
JOIN sale_detail sd ON s.id = sd.sale_id
JOIN product p ON sd.product_id = p.id
JOIN promotion_product pp ON p.id = pp.product_id
JOIN promotion pr ON pp.promotion_id = pr.id
WHERE s.sale_type = 'sale'
    AND s.transaction_date BETWEEN TO_DATE('2025-10-01', 'YYYY-MM-DD') 
    AND TO_DATE('2025-10-31', 'YYYY-MM-DD')
    AND pr.status = 'active'
    AND s.transaction_date BETWEEN pr.date_start AND pr.date_end;

-- consulta 34 (ventas encima del promedio en rango de fechas) --
SELECT 
    p.id AS producto_id,
    p.name AS producto,
    pt.name AS tipo_producto,
    COUNT(DISTINCT s.id) AS numero_ventas,
    SUM(sd.quantity) AS cantidad_vendida,
    SUM(sd.quantity * sd.price) AS total_ventas_producto,
    (SELECT AVG(s2.total) 
    FROM sale s2 
    WHERE s2.sale_type = 'sale'
    AND s2.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
    AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
    ) AS promedio_general_ventas
FROM product p
JOIN sale_detail sd ON p.id = sd.product_id
JOIN sale s ON sd.sale_id = s.id
LEFT JOIN product_type pt ON p.product_type_id = pt.id
WHERE s.sale_type = 'sale'
    AND s.transaction_date 
    BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
    AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
GROUP BY p.id, p.name, pt.name
HAVING SUM(sd.quantity * sd.price) > (
    SELECT AVG(s2.total) 
    FROM sale s2 
    WHERE s2.sale_type = 'sale'
        AND s2.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
        AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
)
ORDER BY total_ventas_producto DESC;

-- consulta 35 (productos que tuvieron más ventas que el producto con menor número de ventas en el mismo año) --
SELECT 
    p.id AS producto_id,
    p.name AS producto,
    pt.name AS tipo_producto,
    COUNT(DISTINCT s.id) AS numero_ventas,
    SUM(sd.quantity) AS cantidad_vendida,
    SUM(sd.quantity * sd.price) AS total_ventas_producto,
    (
        SELECT MIN(ventas_por_producto)
        FROM (
            SELECT SUM(sd2.quantity * sd2.price) AS ventas_por_producto
            FROM sale_detail sd2
            JOIN sale s2 ON sd2.sale_id = s2.id
            WHERE s2.sale_type = 'sale'
            AND EXTRACT(YEAR FROM s2.transaction_date) = 2025
            GROUP BY sd2.product_id
        )
    ) AS minimo_ventas
FROM product p
JOIN sale_detail sd ON p.id = sd.product_id
JOIN sale s ON sd.sale_id = s.id
LEFT JOIN product_type pt ON p.product_type_id = pt.id
WHERE s.sale_type = 'sale'
AND EXTRACT(YEAR FROM s.transaction_date) = 2025
GROUP BY p.id, p.name, pt.name
HAVING SUM(sd.quantity * sd.price) > (
    SELECT MIN(ventas_por_producto)
    FROM (
        SELECT SUM(sd2.quantity * sd2.price) AS ventas_por_producto
        FROM sale_detail sd2
        JOIN sale s2 ON sd2.sale_id = s2.id
        WHERE s2.sale_type = 'sale'
        AND EXTRACT(YEAR FROM s2.transaction_date) = 2025
        GROUP BY sd2.product_id
    )
)
ORDER BY total_ventas_producto DESC;

-- consulta 36 (ubicación de productos con bajo stock) --
SELECT 
    p.id AS producto_id,
    p.name AS producto,
    pt.name AS tipo_producto,
    id_detail.quantity_current AS stock_actual,
    st.name AS tienda,
    a.name AS pasillo,
    sh.description AS estanteria,
    sl.description AS casilla,
    pr.name AS promocion_activa,
    pr.date_start AS inicio_promocion,
    pr.date_end AS fin_promocion,
    (
        SELECT SUM(sd2.quantity)
        FROM sale_detail sd2
        JOIN sale s2 ON sd2.sale_id = s2.id
        WHERE sd2.product_id = p.id
            AND s2.sale_type = 'sale'
            AND s2.transaction_date >= ADD_MONTHS(SYSDATE, -3)
    ) AS cantidad_vendida_ultimos_3_meses,
    CASE 
        WHEN id_detail.quantity_current < 50 THEN 'STOCK BAJO'
        WHEN id_detail.quantity_current BETWEEN 50 AND 100 THEN 'STOCK MEDIO'
        ELSE 'STOCK ALTO'
    END AS estado_stock
FROM product p
LEFT JOIN product_type pt ON p.product_type_id = pt.id
JOIN inventory_detail id_detail ON p.id = id_detail.product_id
JOIN inventory i ON id_detail.inventory_id = i.id
JOIN store st ON i.store_id = st.id
JOIN slot sl ON p.id = sl.product_id
JOIN shelf sh ON sl.shelf_id = sh.id
JOIN aisle a ON sh.aisle_id = a.id
LEFT JOIN promotion_product pp ON p.id = pp.product_id
LEFT JOIN promotion pr ON pp.promotion_id = pr.id AND pr.status = 'active' 
    AND SYSDATE BETWEEN pr.date_start AND pr.date_end
WHERE i.status = 'active'
    AND (
        id_detail.quantity_current < 100 
        OR p.id IN (
            SELECT sd3.product_id
            FROM sale_detail sd3
            JOIN sale s3 ON sd3.sale_id = s3.id
            WHERE s3.sale_type = 'sale'
                AND s3.transaction_date >= ADD_MONTHS(SYSDATE, -3)
            GROUP BY sd3.product_id
            HAVING SUM(sd3.quantity) > (
                SELECT AVG(total_vendido)
                FROM (
                    SELECT SUM(sd4.quantity) AS total_vendido
                    FROM sale_detail sd4
                    JOIN sale s4 ON sd4.sale_id = s4.id
                    WHERE s4.sale_type = 'sale'
                        AND s4.transaction_date >= ADD_MONTHS(SYSDATE, -3)
                    GROUP BY sd4.product_id
                )
            )
        )
    )
ORDER BY 
    CASE WHEN pr.id IS NOT NULL THEN 1 ELSE 2 END,
    id_detail.quantity_current ASC,
    cantidad_vendida_ultimos_3_meses DESC NULLS LAST;

-- consulta 37 (diferencia de productos sin promoción) --
SELECT 
    p.id AS producto_id,
    p.name AS producto,
    pt.name AS tipo_producto,
    st.name AS tienda,
    m.name AS municipio,
    d.name AS departamento,
    st.address AS direccion,
    a.name AS pasillo,
    sh.description AS estanteria,
    sl.description AS casilla,
    sl.price AS precio,
    id_detail.quantity_current AS stock_actual,
    COALESCE(
        (SELECT SUM(sd.quantity)
            FROM sale_detail sd
            JOIN sale s ON sd.sale_id = s.id
            WHERE sd.product_id = p.id
            AND s.sale_type = 'sale'
            AND EXTRACT(YEAR FROM s.transaction_date) = 2025
        ), 0
    ) AS ventas_2025
FROM product p
LEFT JOIN product_type pt ON p.product_type_id = pt.id
JOIN inventory_detail id_detail ON p.id = id_detail.product_id
JOIN inventory i ON id_detail.inventory_id = i.id
JOIN store st ON i.store_id = st.id
JOIN municipality m ON st.municipality_id = m.id
JOIN department d ON m.department_id = d.id
LEFT JOIN slot sl ON p.id = sl.product_id
LEFT JOIN shelf sh ON sl.shelf_id = sh.id
LEFT JOIN aisle a ON sh.aisle_id = a.id AND a.store_id = st.id
WHERE i.status = 'active'
    AND st.name = 'Tienda Mixco'
    AND NOT EXISTS (
        SELECT 1
        FROM promotion_product pp
        JOIN promotion pr ON pp.promotion_id = pr.id
        WHERE pp.product_id = p.id
        AND (EXTRACT(YEAR FROM pr.date_start) = 2025
            OR EXTRACT(YEAR FROM pr.date_end) = 2025)
    )
ORDER BY p.name;

-- consulta 38 (KARDEX) --
WITH movimientos AS (
    -- ENTRADAS POR COMPRAS
    SELECT 
        p.name AS producto,
        'COMPRA' AS tipo_movimiento,
        pu.document AS documento,
        pu.sequence AS secuencia,
        pu.transaction_date AS fecha,
        pd.quantity AS cantidad,
        pd.price AS precio_unitario,
        (pd.quantity * pd.price) AS valor_total,
        st.name AS tienda,
        sup.company_name AS tercero
    FROM product p
    JOIN purchase_detail pd ON p.id = pd.product_id
    JOIN purchase pu ON pd.purchase_id = pu.id
    JOIN store st ON pu.store_id = st.id
    JOIN supplier sup ON pu.supplier_id = sup.id
    WHERE pu.purchase_type = 'order' AND p.id = 1
    
    UNION ALL
    
    -- ENTRADAS POR DEVOLUCIONES DE CLIENTES
    SELECT 
        p.name,
        'DEVOLUCIÓN VENTA',
        s.document,
        s.sequence,
        s.transaction_date,
        sd.quantity,
        sd.price,
        (sd.quantity * sd.price),
        st.name,
        c.first_name || ' ' || c.last_name
    FROM product p
    JOIN sale_detail sd ON p.id = sd.product_id
    JOIN sale s ON sd.sale_id = s.id
    JOIN store st ON s.store_id = st.id
    JOIN client c ON s.client_id = c.id
    WHERE s.sale_type = 'return' AND p.id = 1
    
    UNION ALL
    
    -- SALIDAS POR VENTAS
    SELECT 
        p.name,
        'VENTA',
        s.document,
        s.sequence,
        s.transaction_date,
        -sd.quantity,
        sd.price,
        -(sd.quantity * sd.price),
        st.name,
        c.first_name || ' ' || c.last_name
    FROM product p
    JOIN sale_detail sd ON p.id = sd.product_id
    JOIN sale s ON sd.sale_id = s.id
    JOIN store st ON s.store_id = st.id
    JOIN client c ON s.client_id = c.id
    WHERE s.sale_type = 'sale' AND p.id = 1

    UNION ALL
    
    -- SALIDAS POR DEVOLUCIONES A PROVEEDORES
    SELECT 
        p.name,
        'DEVOLUCIÓN COMPRA',
        pu.document,
        pu.sequence,
        pu.transaction_date,
        -pd.quantity,
        pd.price,
        -(pd.quantity * pd.price),
        st.name,
        sup.company_name
    FROM product p
    JOIN purchase_detail pd ON p.id = pd.product_id
    JOIN purchase pu ON pd.purchase_id = pu.id
    JOIN store st ON pu.store_id = st.id
    JOIN supplier sup ON pu.supplier_id = sup.id
    WHERE pu.purchase_type = 'return' AND p.id = 1
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY fecha, secuencia) AS movimiento,
    fecha,
    tipo_movimiento,
    documento,
    tercero,
    tienda,
    CASE WHEN cantidad > 0 THEN cantidad END AS entrada_cantidad,
    CASE WHEN cantidad > 0 THEN precio_unitario END AS entrada_precio,
    CASE WHEN cantidad > 0 THEN valor_total END AS entrada_valor,
    CASE WHEN cantidad < 0 THEN ABS(cantidad) END AS salida_cantidad,
    CASE WHEN cantidad < 0 THEN precio_unitario END AS salida_precio,
    CASE WHEN cantidad < 0 THEN ABS(valor_total) END AS salida_valor,
    SUM(cantidad) OVER (ORDER BY fecha, secuencia ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS saldo_cantidad,
    SUM(valor_total) OVER (ORDER BY fecha, secuencia ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS saldo_valor
FROM movimientos
ORDER BY fecha, secuencia;rango

-- consulta 39 (top ventas de la tienda de Guatemala) --
SELECT 
    p.id AS producto_id,
    p.name AS producto,
    pt.name AS tipo_producto,
    st.name AS tienda,
    m.name AS municipio,
    d.name AS departamento,
    COALESCE(a.name, 'Sin pasillo') AS pasillo,
    COALESCE(sh.description, 'Sin estantería') AS estanteria,
    COALESCE(sl.description, 'Sin casilla') AS casilla,
    pr.name AS promocion,
    pr.date_start AS inicio_promocion,
    pr.date_end AS fin_promocion,
    COUNT(DISTINCT s.id) AS numero_ventas,
    SUM(sd.quantity) AS cantidad_vendida,
    SUM(sd.quantity * sd.price) AS total_ventas
FROM product p
LEFT JOIN product_type pt ON p.product_type_id = pt.id
JOIN sale_detail sd ON p.id = sd.product_id
JOIN sale s ON sd.sale_id = s.id
JOIN store st ON s.store_id = st.id
JOIN municipality m ON st.municipality_id = m.id
JOIN department d ON m.department_id = d.id
JOIN promotion_product pp ON p.id = pp.product_id
JOIN promotion pr ON pp.promotion_id = pr.id
LEFT JOIN slot sl ON p.id = sl.product_id
LEFT JOIN shelf sh ON sl.shelf_id = sh.id
LEFT JOIN aisle a ON sh.aisle_id = a.id AND a.store_id = st.id
WHERE s.sale_type = 'sale'
    AND pr.status = 'active'
    AND s.transaction_date BETWEEN pr.date_start AND pr.date_end
    AND st.name = 'Tienda SMP'
GROUP BY 
    p.id, p.name, pt.name, st.name, m.name, d.name,
    a.name, sh.description, sl.description, pr.name, pr.date_start, pr.date_end
ORDER BY 
    COALESCE(a.name, 'ZZZZ'), 
    COALESCE(sh.description, 'ZZZZ'), 
    cantidad_vendida DESC;

-- Consulta 40 (actualizar un dato de una tabla) --
UPDATE slot
SET price = 150.00  -- Nuevo precio
WHERE product_id = 1  -- ID del producto
    AND shelf_id IN (
        SELECT sh.id
        FROM shelf sh
        JOIN aisle a ON sh.aisle_id = a.id
        JOIN store st ON a.store_id = st.id
        WHERE st.name = 'Tienda Guatemala'  -- Opcional: filtrar por tienda
    );

-- Consulta 41 (deshabilitar productos en inventario) --
UPDATE inventory
SET status = 'inactive'
WHERE id IN (
    SELECT DISTINCT i.id
    FROM inventory i
    JOIN inventory_detail id_detail ON i.id = id_detail.inventory_id
    WHERE id_detail.product_id NOT IN (
        SELECT DISTINCT sd.product_id
        FROM sale_detail sd
        JOIN sale s ON sd.sale_id = s.id
        WHERE EXTRACT(YEAR FROM s.transaction_date) = 2025
        
        UNION
        
        SELECT DISTINCT pd.product_id
        FROM purchase_detail pd
        JOIN purchase p ON pd.purchase_id = p.id
        WHERE EXTRACT(YEAR FROM p.transaction_date) = 2025
    )
);

-- Consulta 42 (Modificar el stock tras una venta realizada) --
UPDATE inventory_detail
SET quantity_current = quantity_current - 10  -- Cantidad vendida (restar)
WHERE product_id = 1  -- Código/ID del producto
    AND inventory_id IN (
        SELECT i.id
        FROM inventory i
        WHERE i.status = 'active'
        AND i.store_id = (
            SELECT store_id 
            FROM sale 
            WHERE id = 5  -- ID de la venta
        )
    );

-- Consulta 43 (actualizar información de proveedor en fechas específicas) --
UPDATE supplier
SET company_name = 'Proveedor Actualizado S.A.',
    address = 'Dirección Actualizada'
WHERE id IN (
    SELECT DISTINCT pu.supplier_id
    FROM purchase pu
    WHERE pu.transaction_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD')
        AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
        AND pu.supplier_id = 5  -- ID del proveedor específico
);

-- Consulta 44 (Cambiar el estado de una venta) --
CREATE TABLE IF NOT EXISTS sale_delivery_status
(
    id          INT PRIMARY KEY,
    sale_id     INT         NOT NULL,
    status      VARCHAR(50) NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    change_user VARCHAR(100),
    notes       VARCHAR(500),
    FOREIGN KEY (sale_id) REFERENCES sale (id)
);

CREATE SEQUENCE sale_delivery_status_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER sale_delivery_status_bi
    BEFORE INSERT
    ON sale_delivery_status
    FOR EACH ROW
    WHEN (NEW.id IS NULL)
BEGIN
    SELECT sale_delivery_status_seq.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
/

SELECT 
    s.id,
    s.document,
    s.transaction_date,
    s.total,
    st.name AS tienda
FROM sale s
JOIN store st ON s.store_id = st.id
WHERE s.sale_type = 'sale'
    AND s.transaction_date BETWEEN TO_DATE('2025-10-01', 'YYYY-MM-DD')
    AND TO_DATE('2025-10-31', 'YYYY-MM-DD')
    AND NOT EXISTS (
        SELECT 1
        FROM sale_delivery_status sds
        WHERE sds.sale_id = s.id  
    )
ORDER BY s.transaction_date;

-- Paso 3: Cambiar a 'delivered'
INSERT INTO sale_delivery_status (sale_id, status, change_user, notes)
SELECT 
    s.id,
    'delivered',
    s.transaction_user,
    'Entregas de octubre 2025'
FROM sale s
WHERE s.sale_type = 'sale'
    AND s.transaction_date 
    BETWEEN TO_DATE('2025-10-01', 'YYYY-MM-DD')
    AND TO_DATE('2025-10-31', 'YYYY-MM-DD');

-- Paso 4: Verificar
SELECT 
    s.id,
    s.document,
    s.transaction_date,
    sds.status,
    sds.change_date
FROM sale s
JOIN sale_delivery_status sds ON s.id = sds.sale_id
WHERE s.transaction_date 
    BETWEEN TO_DATE('2025-10-01', 'YYYY-MM-DD')
    AND TO_DATE('2025-10-31', 'YYYY-MM-DD')
ORDER BY s.transaction_date;

