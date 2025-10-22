-- =======================
-- Insert de Tiendas
-- =======================

INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Cobán', 'Av. Central 12-34, Zona 1', 1);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Cobán', 'Av. Sur, Zona 4', 1);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda SCV', 'San Cristóbal Verapaz, Zona 4', 3);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Tactic', 'Calle Principal, Zona 1', 4);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Salamá', 'Av. Principal, Zona 1', 18);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Chimaltenango', 'Av. Principal, Zona 1', 26);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda SJC', 'San Juan Comalapa, Zona 2', 29);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Tecpán', 'Tecpán, Zona 6', 31);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Acatenango', 'Sobre la carretera principal', 36);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda El Tejar', 'Sobre la carretera principal', 41);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Chiquimula', 'Calle principal, Zona 1', 42);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Esquipulas', 'Calle principal, Zona 1', 48);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Guastatoya', 'Av. Principal, Zona 1', 53);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Escuintla', 'Av. Sur, Zona 4', 61);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda SLC', 'Santa Lucia Cotzumalguapa, Zona 3', 62);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Palin', 'Centro Comercial Palin', 71);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Guatemala', 'Zona 1', 74);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Mixco', 'PeriRoosevelt, Zona 7', 81);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Villa Nueva', 'Centro Comercial Santa Clara', 88);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda SMP', 'San Miguel Petapa, Zona 5', 90);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Huehuetenango', 'Huehuetenango, Zona 1', 91);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Soloma', 'Soloma, Zona 5', 98);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda PB', 'Puerto Barrios, Zona 1', 123);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Livingston', 'Av. Principal, Zona 1', 124);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Livingston', 'Av. Principal, Zona 1', 124);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda El Progreso', 'El Progreso, Zona 6', 136);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Quetzaltenango', 'Av. Principal, Zona 1', 166);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Coatepeque', 'Calle Principal, Zona 1', 185);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Reu', 'Av. Norte, Zona 5', 211);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Antigua', '6ta calle', 220);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda SLS', 'San Lucas Sacatepéquez, Las puertas', 227);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Chiquimula', 'San Antonio, Zona 1', 273);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Solola', 'Av. Principal, Zona 1', 280);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Mazatenango', 'Av. Principal, Zona 1', 299);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Totonicapan', 'Av. Principal, Zona 1', 320);
INSERT INTO store (name, address, municipality_id) VALUES ('Tienda Zacapa', 'Av. Principal, Zona 1', 328);

-- ============================================
-- POBLACIÓN DE ESTRUCTURA ESTÁNDAR
-- Pasillos, Estanterías y Slots
-- ============================================

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