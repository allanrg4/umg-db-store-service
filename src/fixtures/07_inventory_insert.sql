-- ========================================================
--                  Insert de Inventario
-- ========================================================
DECLARE
   v_emp_id INT;
   v_store_id INT := 1;
BEGIN
   FOR emp IN (
      SELECT id FROM employee
      WHERE employee_type_id = 10
      ORDER BY id
   ) LOOP
      -- Asignar empleado a tienda
      v_emp_id := emp.id;

      INSERT INTO inventory (
         store_id, employee_id,
         created_at, date_start, date_end, status
      )
      VALUES (
         v_store_id, v_emp_id,
         TO_DATE('2025-01-01', 'YYYY-MM-DD'),
         TO_DATE('2025-01-01', 'YYYY-MM-DD'),
         TO_DATE('2025-12-31', 'YYYY-MM-DD'),
         'active'
      );

      v_store_id := v_store_id + 1;
   END LOOP;
END;
/

DECLARE
   v_price NUMBER(10,2);
   v_quantity_start INT;
   v_quantity_end INT;
   v_quantity_current INT;
BEGIN
   FOR inv IN (SELECT id, store_id FROM inventory) LOOP
      FOR prod IN (SELECT id, product_type_id FROM product) LOOP
         -- Precios lógicos según tipo
         CASE prod.product_type_id
            WHEN 1 THEN v_price := 15;   -- Abarrotes
            WHEN 2 THEN v_price := 8;    -- Bebidas
            WHEN 3 THEN v_price := 20;   -- Lácteos
            WHEN 4 THEN v_price := 12;   -- Panadería
            WHEN 5 THEN v_price := 35;   -- Carnes
            WHEN 6 THEN v_price := 18;   -- Frutas y verduras
            WHEN 7 THEN v_price := 25;   -- Congelados
            WHEN 8 THEN v_price := 30;   -- Limpieza
            WHEN 9 THEN v_price := 28;   -- Higiene
            WHEN 10 THEN v_price := 40;  -- Bebé
            WHEN 11 THEN v_price := 22;  -- Mascotas
            WHEN 12 THEN v_price := 50;  -- Ferretería
            WHEN 13 THEN v_price := 120; -- Electrónica
            WHEN 14 THEN v_price := 200; -- Electrodomésticos
            WHEN 15 THEN v_price := 10;  -- Papelería
            WHEN 16 THEN v_price := 35;  -- Juguetes
            WHEN 17 THEN v_price := 80;  -- Ropa Hombre
            WHEN 18 THEN v_price := 75;  -- Ropa Mujer
            WHEN 19 THEN v_price := 60;  -- Ropa Niño
            WHEN 20 THEN v_price := 90;  -- Calzado
            WHEN 21 THEN v_price := 110; -- Deportes
            WHEN 22 THEN v_price := 150; -- Automotriz
            WHEN 23 THEN v_price := 130; -- Hogar y Decoración
            WHEN 24 THEN v_price := 55;  -- Jardinería
            ELSE v_price := 25;
         END CASE;

         -- Cantidades aleatorias
         v_quantity_start := TRUNC(DBMS_RANDOM.VALUE(50, 300));
         v_quantity_end := TRUNC(DBMS_RANDOM.VALUE(50, 300));
         v_quantity_current := TRUNC(DBMS_RANDOM.VALUE(50, 300));

         -- Insertar detalle
         INSERT INTO inventory_detail (
            inventory_id, product_id,
            quantity_start, quantity_end, quantity_current,
            price_start, price_end, price_current,
            transaction_date
         )
         VALUES (
            inv.id, prod.id,
            v_quantity_start, v_quantity_end, v_quantity_current,
            v_price, v_price, v_price,
            SYSDATE
         );
      END LOOP;
   END LOOP;
END;
/
