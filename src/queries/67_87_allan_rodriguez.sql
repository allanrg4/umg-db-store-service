-- 67
WITH sold AS (SELECT DISTINCT sd.product_id
              FROM sale s
                       JOIN sale_detail sd ON sd.sale_id = s.id
              WHERE s.transaction_date >= :start_date
                AND s.transaction_date < :end_date),
     returned AS (SELECT DISTINCT sd.product_id
                  FROM sale s
                           JOIN sale_detail sd ON sd.sale_id = s.id
                  WHERE s.transaction_date >= :start_date
                    AND s.transaction_date < :end_date
                    AND (s.sale_type = 'RETURN' OR sd.quantity < 0))
SELECT p.id, p.name
FROM product p
         JOIN sold s ON s.product_id = p.id
         LEFT JOIN returned r ON r.product_id = p.id
WHERE r.product_id IS NULL
ORDER BY p.name;

-- 68
WITH per_day AS (SELECT TRUNC(s.transaction_date) AS day, COUNT(*) AS sales_count
                 FROM sale s
                 WHERE s.transaction_date >= :start_date
                   AND s.transaction_date < :end_date
                 GROUP BY TRUNC(s.transaction_date)),
     mx AS (SELECT MAX(sales_count) AS m FROM per_day)
SELECT d.day, d.sales_count
FROM per_day d,
     mx
WHERE d.sales_count = mx.m
ORDER BY d.day;

-- 69
WITH sales AS (SELECT sd.product_id, AVG(sd.price) AS avg_sale_price
               FROM sale s
                        JOIN sale_detail sd ON sd.sale_id = s.id
               WHERE s.transaction_date >= :start_date
                 AND s.transaction_date < :end_date
               GROUP BY sd.product_id),
     costs AS (SELECT pd.product_id, AVG(pd.price) AS avg_cost_price
               FROM purchase p
                        JOIN purchase_detail pd ON pd.purchase_id = p.id
               WHERE p.transaction_date >= :start_date
                 AND p.transaction_date < :end_date
               GROUP BY pd.product_id)
SELECT p.id,
       p.name,
       s.avg_sale_price,
       c.avg_cost_price,
       (s.avg_sale_price - c.avg_cost_price) AS margin
FROM product p
         JOIN sales s ON s.product_id = p.id
         JOIN costs c ON c.product_id = p.id
ORDER BY margin DESC NULLS LAST
    FETCH FIRST :limit_n ROWS ONLY;

-- 70
SELECT s.sale_type  AS payment_method,
       SUM(s.total) AS total_sales
FROM sale s
WHERE s.transaction_date >= :start_date
  AND s.transaction_date < :end_date
GROUP BY s.sale_type
ORDER BY total_sales DESC;

-- 71
SELECT d.name   AS department,
       m.name   AS municipality,
       c.id,
       c.first_name,
       c.last_name,
       COUNT(*) AS return_txn_count
FROM sale s
         JOIN sale_detail sd ON sd.sale_id = s.id
         JOIN client c ON c.id = s.client_id
         JOIN store st ON st.id = s.store_id
         JOIN municipality m ON m.id = st.municipality_id
         JOIN department d ON d.id = c.department_id
WHERE s.transaction_date >= :start_date
  AND s.transaction_date < :end_date
  AND (s.sale_type = 'RETURN' OR sd.quantity < 0)
GROUP BY d.name, m.name, c.id, c.first_name, c.last_name
ORDER BY d.name, m.name, c.last_name, c.first_name;

-- 72
SELECT p.id,
       p.name,
       NVL(SUM(CASE WHEN sd.quantity > 0 THEN sd.quantity ELSE 0 END), 0) AS units_sold
FROM product p
         LEFT JOIN sale_detail sd ON sd.product_id = p.id
         LEFT JOIN sale s ON s.id = sd.sale_id
    AND s.store_id = :store_id
    AND s.transaction_date >= :start_date
    AND s.transaction_date < :end_date
GROUP BY p.id, p.name
ORDER BY units_sold ASC, p.name
    FETCH FIRST :limit_n ROWS ONLY;

-- 73
SELECT pt.name          AS product_type,
       SUM(sd.quantity) AS units_sold
FROM sale_detail sd
         JOIN sale s ON s.id = sd.sale_id
         JOIN product p ON p.id = sd.product_id
         JOIN product_type pt ON pt.id = p.product_type_id
WHERE s.transaction_date >= :start_date
  AND s.transaction_date < :end_date
GROUP BY pt.name
ORDER BY pt.name;

-- 74, 75
WITH priced AS (SELECT pt.id   AS product_type_id,
                       pt.name AS product_type,
                       p.id    AS product_id,
                       p.name  AS product_name,
                       slt.price,
                       ROW_NUMBER() OVER (
                           PARTITION BY pt.id
                           ORDER BY slt.price DESC, p.name
                           )   AS rn
                FROM product p
                         JOIN product_type pt ON pt.id = p.product_type_id
                         JOIN slot slt ON slt.product_id = p.id)
SELECT product_type_id, product_type, product_id, product_name, price AS max_price
FROM priced
WHERE rn = 1
ORDER BY product_type;

-- 76
SELECT c.id,
       c.first_name,
       c.last_name,
       COUNT(s.id)  AS purchase_count,
       SUM(s.total) AS total_spent
FROM client c
         JOIN sale s ON s.client_id = c.id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spent DESC
    FETCH FIRST 10 ROWS ONLY;

--77
WITH all_stores AS (SELECT COUNT(*) AS n FROM store),
     per_client AS (SELECT s.client_id, COUNT(DISTINCT s.store_id) AS stores_visited
                    FROM sale s
                    GROUP BY s.client_id)
SELECT c.id, c.first_name, c.last_name, pc.stores_visited
FROM per_client pc
         JOIN all_stores a ON a.n = pc.stores_visited
         JOIN client c ON c.id = pc.client_id
ORDER BY c.last_name, c.first_name;

-- 78
WITH days AS (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1)) + LEVEL - 1 AS day
              FROM dual
              CONNECT BY LEVEL <= TRUNC(SYSDATE) - TRUNC(ADD_MONTHS(SYSDATE, -1)) + 1),
     per_day AS (SELECT d.day,
                        NVL(SUM(s.total), 0) AS total_day
                 FROM days d
                          LEFT JOIN sale s
                                    ON TRUNC(s.transaction_date) = d.day
                 GROUP BY d.day)
SELECT AVG(total_day) AS avg_sales_per_day_last_month
FROM per_day;

-- 79
SELECT pt.name                     AS product_type,
       SUM(sd.quantity * sd.price) AS gross_sales
FROM sale_detail sd
         JOIN sale s ON s.id = sd.sale_id
         JOIN product p ON p.id = sd.product_id
         JOIN product_type pt ON pt.id = p.product_type_id
GROUP BY pt.name
HAVING SUM(sd.quantity * sd.price) > 1000000
ORDER BY gross_sales DESC;

-- 80
SELECT pt.name          AS product_type,
       SUM(sd.quantity) AS units_sold
FROM sale_detail sd
         JOIN sale s ON s.id = sd.sale_id
         JOIN product p ON p.id = sd.product_id
         JOIN product_type pt ON pt.id = p.product_type_id
GROUP BY pt.name
HAVING SUM(sd.quantity) > 1000000
ORDER BY units_sold DESC;

-- 81
SELECT p.id,
       p.name,
       COUNT(*)                                                        AS devoluciones,
       SUM(ABS(CASE WHEN sd.quantity < 0 THEN sd.quantity ELSE 0 END)) AS unidades_devueltas
FROM sale s
         JOIN sale_detail sd ON sd.sale_id = s.id
         JOIN product p ON p.id = sd.product_id
WHERE s.transaction_date >= :start_date
  AND s.transaction_date < :end_date
  AND (s.sale_type = 'RETURN' OR sd.quantity < 0)
GROUP BY p.id, p.name
ORDER BY devoluciones DESC, unidades_devueltas DESC, p.name;

-- 82
SELECT p.id,
       p.name,
       COUNT(*)                                                        AS devoluciones,
       SUM(ABS(CASE WHEN sd.quantity < 0 THEN sd.quantity ELSE 0 END)) AS unidades_devueltas
FROM sale s
         JOIN sale_detail sd ON sd.sale_id = s.id
         JOIN product p ON p.id = sd.product_id
WHERE s.transaction_date >= :start_date
  AND s.transaction_date < :end_date
  AND (s.sale_type = 'RETURN' OR sd.quantity < 0)
GROUP BY p.id, p.name
ORDER BY devoluciones DESC, unidades_devueltas DESC, p.name
    FETCH FIRST :limit_n ROWS ONLY;

-- 83
WITH dev_por_dia AS (SELECT TRUNC(s.transaction_date) AS dia,
                            COUNT(*)                  AS devoluciones
                     FROM sale s
                              JOIN sale_detail sd ON sd.sale_id = s.id
                     WHERE s.transaction_date >= :start_date
                       AND s.transaction_date < :end_date
                       AND (s.sale_type = 'RETURN' OR sd.quantity < 0)
                     GROUP BY TRUNC(s.transaction_date)),
     mx AS (SELECT MAX(devoluciones) AS m FROM dev_por_dia)
SELECT d.dia, d.devoluciones
FROM dev_por_dia d,
     mx
WHERE d.devoluciones = mx.m
ORDER BY d.dia;

-- 84
SELECT s.sale_type  AS payment_method,
       COUNT(*)     AS ventas,
       SUM(s.total) AS ingresos
FROM sale s
WHERE s.transaction_date >= :start_date
  AND s.transaction_date < :end_date
  AND (s.sale_type <> 'RETURN')
GROUP BY s.sale_type
ORDER BY ingresos DESC, ventas DESC;

-- 85
SELECT st.id   AS store_id,
       st.name AS store_name,
       e.id    AS employee_id,
       e.first_name,
       e.last_name
FROM employee e
         JOIN store st ON st.id = e.store_id
ORDER BY st.name DESC, e.last_name, e.first_name;

-- 86
WITH precios AS (SELECT pt.id   AS product_type_id,
                        pt.name AS product_type,
                        p.id    AS product_id,
                        p.name  AS product_name,
                        slt.price,
                        ROW_NUMBER() OVER (
                            PARTITION BY pt.id
                            ORDER BY slt.price ASC, p.name
                            )   AS rn
                 FROM product p
                          JOIN product_type pt ON pt.id = p.product_type_id
                          JOIN slot slt ON slt.product_id = p.id)
SELECT product_type_id, product_type, product_id, product_name, price AS min_price
FROM precios
WHERE rn = 1
ORDER BY product_type;

-- 87
SELECT sp.supplier_id,
       sup.company_name,
       SUM(sd.quantity) AS unidades_vendidas
FROM sale_detail sd
         JOIN sale s ON s.id = sd.sale_id
         JOIN supplier_product sp ON sp.product_id = sd.product_id
         JOIN supplier sup ON sup.id = sp.supplier_id
WHERE s.transaction_date >= :start_date
  AND s.transaction_date < :end_date
GROUP BY sp.supplier_id, sup.company_name
HAVING SUM(sd.quantity) > 1000
ORDER BY unidades_vendidas DESC, sup.company_name;
