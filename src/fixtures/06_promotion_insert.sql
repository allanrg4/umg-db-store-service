-- =========================================================
--                   Insert de Promociones
-- =========================================================

DECLARE
   v_store_id   INT;
   v_type_id    INT;
   v_name       VARCHAR2(255);
   v_start      DATE;
   v_end        DATE;
   v_status     VARCHAR2(50);
BEGIN
   FOR v_type_id IN 1..24 LOOP
      FOR i IN 1..3 LOOP
         -- Seleccionar tienda aleatoria entre 1 y 36
         v_store_id := TRUNC(DBMS_RANDOM.VALUE(1, 37));

         -- Nombre de la promoción
         v_name := 'Promo Tipo ' || v_type_id || ' - Tienda ' || v_store_id;

         -- Fechas aleatorias
         CASE MOD(i, 3)
            WHEN 0 THEN  -- pasada
               v_start := SYSDATE - DBMS_RANDOM.VALUE(30, 60);
               v_end   := v_start + DBMS_RANDOM.VALUE(5, 15);
               v_status := 'inactive';
            WHEN 1 THEN  -- actual
               v_start := SYSDATE - DBMS_RANDOM.VALUE(1, 5);
               v_end   := SYSDATE + DBMS_RANDOM.VALUE(5, 10);
               v_status := 'active';
            WHEN 2 THEN  -- futura
               v_start := SYSDATE + DBMS_RANDOM.VALUE(5, 15);
               v_end   := v_start + DBMS_RANDOM.VALUE(5, 10);
               v_status := 'active';
         END CASE;

         -- Insertar promoción
         INSERT INTO promotion (store_id, name, status, date_start, date_end)
         VALUES (v_store_id, v_name, v_status, v_start, v_end);
      END LOOP;
   END LOOP;
END;
/

DECLARE
   v_type_id INT;
BEGIN
   FOR promo IN (SELECT id, name FROM promotion) LOOP
      -- Extraer el tipo desde el nombre de la promoción
      v_type_id := TO_NUMBER(REGEXP_SUBSTR(promo.name, '\d+', 1, 1));

      -- Insertar productos que coincidan con ese tipo
      INSERT INTO promotion_product (promotion_id, product_id)
      SELECT promo.id, id
      FROM product
      WHERE product_type_id = v_type_id;
   END LOOP;
END;
/
