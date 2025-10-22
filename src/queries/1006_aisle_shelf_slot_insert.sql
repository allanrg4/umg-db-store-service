-- ============================================
-- POBLACIÓN DE ESTRUCTURA ESTÁNDAR
-- Pasillos, Estanterías y Slots
-- ============================================
-- REQUISITOS PREVIOS:
-- 1. Departamentos insertados
-- 2. Municipios insertados
-- 3. Product_types insertados
-- 4. Products insertados
-- 5. Stores insertadas (36 tiendas)

DECLARE
   v_store_id        INT;
   v_aisle_id        INT;
   v_shelf_id        INT;
   v_aisle_name      VARCHAR2(50);
   v_shelf_desc      VARCHAR2(50);
   v_product_id      INT := 1;
   v_base_price      DECIMAL(10,2);
   v_total_products  INT;
   
   -- Cursor para recorrer todas las tiendas
   CURSOR c_stores IS
      SELECT id FROM store ORDER BY id;
   
   -- Array de nombres de pasillos (8 pasillos estándar)
   TYPE t_aisle_names IS TABLE OF VARCHAR2(50);
   v_aisle_names t_aisle_names := t_aisle_names(
      'Abarrotes',
      'Lácteos y Derivados',
      'Carnes y Embutidos',
      'Panadería',
      'Bebidas',
      'Limpieza',
      'Electrónica',
      'Ropa y Textiles'
   );
   
BEGIN
   -- Obtener el total de productos disponibles
   SELECT COUNT(*) INTO v_total_products FROM product;
   
   -- Recorrer cada tienda
   FOR store_rec IN c_stores LOOP
      v_store_id := store_rec.id;
      
      -- Recorrer cada pasillo (8 pasillos por tienda)
      FOR i IN 1..v_aisle_names.COUNT LOOP
         v_aisle_name := v_aisle_names(i);
         
         -- Insertar pasillo (el trigger asigna el ID automáticamente)
         INSERT INTO aisle (name, store_id)
         VALUES (v_aisle_name, v_store_id)
         RETURNING id INTO v_aisle_id;
         
         -- Crear 4 estanterías por pasillo (A, B, C, D)
         FOR j IN 1..4 LOOP
            v_shelf_desc := 'Estantería ' || CHR(64 + j); -- A=65, B=66, C=67, D=68
            
            -- Insertar estantería (el trigger asigna el ID automáticamente)
            INSERT INTO shelf (description, aisle_id)
            VALUES (v_shelf_desc, v_aisle_id)
            RETURNING id INTO v_shelf_id;
            
            -- Crear 5 slots por estantería
            FOR k IN 1..5 LOOP
               -- Calcular precio base según categoría del pasillo
               CASE i
                  WHEN 1 THEN v_base_price := ROUND(DBMS_RANDOM.VALUE(5, 25), 2);    -- Abarrotes
                  WHEN 2 THEN v_base_price := ROUND(DBMS_RANDOM.VALUE(8, 35), 2);    -- Lácteos
                  WHEN 3 THEN v_base_price := ROUND(DBMS_RANDOM.VALUE(15, 60), 2);   -- Carnes
                  WHEN 4 THEN v_base_price := ROUND(DBMS_RANDOM.VALUE(3, 20), 2);    -- Panadería
                  WHEN 5 THEN v_base_price := ROUND(DBMS_RANDOM.VALUE(3, 15), 2);    -- Bebidas
                  WHEN 6 THEN v_base_price := ROUND(DBMS_RANDOM.VALUE(10, 40), 2);   -- Limpieza
                  WHEN 7 THEN v_base_price := ROUND(DBMS_RANDOM.VALUE(50, 300), 2);  -- Electrónica
                  WHEN 8 THEN v_base_price := ROUND(DBMS_RANDOM.VALUE(25, 150), 2);  -- Ropa
                  ELSE v_base_price := ROUND(DBMS_RANDOM.VALUE(10, 50), 2);
               END CASE;
               
               -- Asignar product_id de forma cíclica
               v_product_id := MOD((i-1)*20 + (j-1)*5 + k - 1, v_total_products) + 1;
               
               -- Insertar slot (el trigger asigna el ID automáticamente)
               INSERT INTO slot (shelf_id, product_id, price, description)
               VALUES (
                  v_shelf_id,
                  v_product_id,
                  v_base_price,
                  'Slot ' || k || ' - ' || v_shelf_desc
               );
               
            END LOOP; -- Fin slots
            
         END LOOP; -- Fin estanterías
         
      END LOOP; -- Fin pasillos
      
      COMMIT;
      
   END LOOP; -- Fin tiendas
   
END;
/

-- ============================================
-- QUERIES DE VERIFICACIÓN
-- ============================================

-- 1. Resumen general por tienda
SELECT 
   s.id AS tienda_id,
   s.name AS tienda_nombre,
   COUNT(DISTINCT a.id) AS total_pasillos,
   COUNT(DISTINCT sh.id) AS total_estanterias,
   COUNT(sl.id) AS total_slots
FROM store s
LEFT JOIN aisle a ON s.id = a.store_id
LEFT JOIN shelf sh ON a.id = sh.aisle_id
LEFT JOIN slot sl ON sh.id = sl.shelf_id
GROUP BY s.id, s.name
ORDER BY s.id;

-- 2. Verificar totales generales
SELECT 
   (SELECT COUNT(*) FROM store) AS total_tiendas,
   (SELECT COUNT(*) FROM aisle) AS total_pasillos,
   (SELECT COUNT(*) FROM shelf) AS total_estanterias,
   (SELECT COUNT(*) FROM slot) AS total_slots
FROM dual;

-- 3. Ver estructura completa de la primera tienda
SELECT 
   s.name AS tienda,
   a.name AS pasillo,
   sh.description AS estanteria,
   sl.description AS slot_desc,
   p.name AS producto,
   sl.price AS precio
FROM store s
JOIN aisle a ON s.id = a.store_id
JOIN shelf sh ON a.id = sh.aisle_id
JOIN slot sl ON sh.id = sl.shelf_id
JOIN product p ON sl.product_id = p.id
WHERE s.id = 1
ORDER BY a.id, sh.id, sl.id;

-- 4. Verificar que todas las tiendas tienen la misma estructura
SELECT 
   s.id,
   COUNT(DISTINCT a.id) AS pasillos,
   COUNT(DISTINCT sh.id) AS estanterias,
   COUNT(sl.id) AS slots
FROM store s
LEFT JOIN aisle a ON s.id = a.store_id
LEFT JOIN shelf sh ON a.id = sh.aisle_id
LEFT JOIN slot sl ON sh.id = sl.shelf_id
GROUP BY s.id
ORDER BY s.id;