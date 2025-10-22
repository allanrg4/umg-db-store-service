-- ==============================================
--                 150 COMPRAS 
-- ==============================================
DECLARE
   v_supplier_id INT;
   v_employee_id INT;
   v_store_id INT;
   v_total NUMBER(10,2);
   v_doc VARCHAR2(100);
   v_seq VARCHAR2(50);
   v_user VARCHAR2(100);
   v_date DATE;
BEGIN
   FOR i IN 1..150 LOOP
      v_store_id := TRUNC(DBMS_RANDOM.VALUE(1, 37));

      SELECT id INTO v_employee_id
      FROM (
         SELECT id
         FROM employee
         WHERE employee_type_id = 1 AND store_id = v_store_id
         ORDER BY DBMS_RANDOM.VALUE
      )
      WHERE ROWNUM = 1;

      v_supplier_id := TRUNC(DBMS_RANDOM.VALUE(1, 17));

      v_doc := 'ORD-' || TO_CHAR(i, 'FM0000');
      v_seq := 'SEQ-' || TO_CHAR(i, 'FM0000');
      v_user := 'system';
      v_date := SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 365));
      v_total := TRUNC(DBMS_RANDOM.VALUE(200, 1500), 2);

      INSERT INTO purchase (
         purchase_type, document, sequence, total,
         transaction_date, transaction_user,
         employee_id, store_id, supplier_id
      )
      VALUES (
         'order', v_doc, v_seq, v_total,
         v_date, v_user,
         v_employee_id, v_store_id, v_supplier_id
      );
   END LOOP;
END;
/

-- ==============================================
--            150 DETALLES DE COMPRAS
-- ==============================================
DECLARE
   v_line INT;
   v_price NUMBER(10,2);
   v_quantity INT;
BEGIN
   FOR pur IN (SELECT id FROM purchase) LOOP
      v_line := 1;
      FOR prod IN (
         SELECT id, product_type_id FROM product
         WHERE ROWNUM <= 5
      ) LOOP
         CASE prod.product_type_id
            WHEN 1 THEN v_price := 15;
            WHEN 2 THEN v_price := 8;
            WHEN 3 THEN v_price := 20;
            WHEN 4 THEN v_price := 12;
            WHEN 5 THEN v_price := 35;
            ELSE v_price := 25;
         END CASE;

         v_quantity := TRUNC(DBMS_RANDOM.VALUE(10, 100));

         INSERT INTO purchase_detail (
            line, purchase_id, product_id,
            quantity, price, transaction_date, transaction_user
         )
         VALUES (
            v_line, pur.id, prod.id,
            v_quantity, v_price, SYSDATE, 'system'
         );

         v_line := v_line + 1;
      END LOOP;
   END LOOP;
END;
/

-- ==============================================
--                 650 VENTAS
-- ==============================================
DECLARE
   v_client_id INT;
   v_employee_id INT;
   v_store_id INT;
   v_total NUMBER(10,2);
   v_doc VARCHAR2(100);
   v_seq VARCHAR2(50);
   v_user VARCHAR2(100);
   v_date DATE;
BEGIN
   FOR i IN 1..650 LOOP
      v_store_id := TRUNC(DBMS_RANDOM.VALUE(1, 37));

      SELECT id INTO v_employee_id
         FROM (
            SELECT id
            FROM employee
            WHERE employee_type_id = 3 AND store_id = v_store_id
            ORDER BY DBMS_RANDOM.VALUE
         )
         WHERE ROWNUM = 1;

      SELECT id INTO v_client_id
      FROM client
      WHERE status = 'active'
      AND ROWNUM = 1;


      v_doc := 'SALE-' || TO_CHAR(i, 'FM0000');
      v_seq := 'SEQ-' || TO_CHAR(i, 'FM0000');
      v_user := 'system';
      v_date := SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 365));
      v_total := TRUNC(DBMS_RANDOM.VALUE(50, 800), 2);

      INSERT INTO sale (
         sale_type, document, sequence, total,
         transaction_date, transaction_user,
         store_id, employee_id, client_id
      )
      VALUES (
         'sale', v_doc, v_seq, v_total,
         v_date, v_user,
         v_store_id, v_employee_id, v_client_id
      );
   END LOOP;
END;
/

-- ==============================================
--            650 DETALLES DE VENTAS
-- ==============================================
DECLARE
   v_line INT;
   v_price NUMBER(10,2);
   v_quantity INT;
BEGIN
   FOR s IN (SELECT id FROM sale) LOOP
      v_line := 1;
      FOR prod IN (
         SELECT id, product_type_id FROM product
         WHERE ROWNUM <= 3
      ) LOOP
         CASE prod.product_type_id
            WHEN 1 THEN v_price := 18;
            WHEN 2 THEN v_price := 10;
            WHEN 3 THEN v_price := 25;
            WHEN 4 THEN v_price := 15;
            WHEN 5 THEN v_price := 40;
            ELSE v_price := 30;
         END CASE;

         v_quantity := TRUNC(DBMS_RANDOM.VALUE(1, 10));

         INSERT INTO sale_detail (
            line, sale_id, product_id,
            quantity, price, transaction_date, transaction_user
         )
         VALUES (
            v_line, s.id, prod.id,
            v_quantity, v_price, SYSDATE, 'system'
         );

         v_line := v_line + 1;
      END LOOP;
   END LOOP;
END;
/