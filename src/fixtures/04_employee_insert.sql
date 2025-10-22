-- ============================================
--            TIPOS DE EMPLEADOS
-- ============================================

INSERT INTO employee_type (name) VALUES ('Gerente de Tienda');
INSERT INTO employee_type (name) VALUES ('Subgerente');
INSERT INTO employee_type (name) VALUES ('Cajero');
INSERT INTO employee_type (name) VALUES ('Supervisor de Piso');
INSERT INTO employee_type (name) VALUES ('Empleado de Almacén');
INSERT INTO employee_type (name) VALUES ('Carnicero');
INSERT INTO employee_type (name) VALUES ('Panadero');
INSERT INTO employee_type (name) VALUES ('Empleado de Limpieza');
INSERT INTO employee_type (name) VALUES ('Guardia de Seguridad');
INSERT INTO employee_type (name) VALUES ('Encargado de Inventario');

COMMIT;

-- ============================================
--       POBLACIÓN DE EMPLEADOS ÚNICOS
-- ============================================

DECLARE
   v_store_id INT;
   v_employee_counter INT := 0;
   
   TYPE t_names IS TABLE OF VARCHAR2(200);
   
   v_first_names_m t_names := t_names(
      'José', 'Carlos', 'Luis', 'Mario', 'Jorge', 'Oscar', 'Francisco', 'Roberto',
      'Miguel', 'Pedro', 'Juan', 'Diego', 'Alejandro', 'Fernando', 'Ricardo', 'Manuel',
      'Sergio', 'Rafael', 'Ernesto', 'Héctor', 'Guillermo', 'César', 'Rodrigo', 'Alberto',
      'Javier', 'Raúl', 'Arturo', 'Enrique', 'Pablo', 'Andrés', 'Daniel', 'Gabriel',
      'Marco', 'Antonio', 'Eduardo', 'Víctor', 'Ramón', 'Salvador', 'Armando', 'Felipe',
      'Rubén', 'Gerardo', 'Alfredo', 'Lorenzo', 'Mauricio', 'Julio', 'Ángel', 'Emilio'
   );
   
   v_first_names_f t_names := t_names(
      'María', 'Ana', 'Carmen', 'Rosa', 'Luisa', 'Patricia', 'Elena', 'Sandra',
      'Gabriela', 'Claudia', 'Sofía', 'Marta', 'Laura', 'Julia', 'Silvia', 'Beatriz',
      'Andrea', 'Cristina', 'Diana', 'Isabel', 'Mónica', 'Teresa', 'Raquel', 'Fernanda',
      'Gloria', 'Verónica', 'Leticia', 'Cecilia', 'Mariana', 'Carolina', 'Daniela', 'Karla',
      'Alejandra', 'Paola', 'Lucía', 'Adriana', 'Natalia', 'Rocío', 'Elisa', 'Victoria',
      'Miriam', 'Brenda', 'Lorena', 'Yolanda', 'Esther', 'Sonia', 'Irma', 'Norma'
   );
   
   v_last_names t_names := t_names(
      'García', 'Rodríguez', 'López', 'Martínez', 'González', 'Pérez', 'Sánchez', 'Ramírez',
      'Torres', 'Flores', 'Rivera', 'Gómez', 'Díaz', 'Cruz', 'Morales', 'Hernández',
      'Jiménez', 'Álvarez', 'Castillo', 'Romero', 'Gutiérrez', 'Muñoz', 'Méndez', 'Vásquez',
      'Reyes', 'Ortiz', 'Ruiz', 'Vargas', 'Castro', 'Ramos', 'Aguilar', 'Domínguez',
      'Herrera', 'Medina', 'Navarro', 'Campos', 'Núñez', 'Cortés', 'Guerrero', 'Vega',
      'León', 'Chávez', 'Contreras', 'Estrada', 'Moreno', 'Soto', 'Figueroa', 'Miranda'
   );
   
   v_second_last_names t_names := t_names(
      'de León', 'Monzón', 'Barrios', 'Sandoval', 'Pineda', 'Saenz', 'Marroquín', 'Quiñonez',
      'Cabrera', 'Velásquez', 'Mejía', 'Escobar', 'Porras', 'Mazariegos', 'Orozco', 'Peña',
      'Valladares', 'Recinos', 'Ayala', 'Fuentes', 'Maldonado', 'Carrillo', 'Cordón', 'Arriaga',
      'Monterroso', 'Solares', 'Coronado', 'Rosales', 'Alvarado', 'Monterroso', 'Lemus', 'Tello',
      'Batres', 'Godínez', 'Corado', 'Dávila', 'Archila', 'Cifuentes', 'Palma', 'Urizar',
      'Bran', 'Coloma', 'Duarte', 'Paniagua', 'Salguero', 'Yoc', 'Ajú', 'Tax'
   );
   
   v_first_name VARCHAR2(200);
   v_last_name VARCHAR2(200);
   v_address VARCHAR2(200);
   v_idx1 INT;
   v_idx2 INT;
   v_idx3 INT;
   
   CURSOR c_stores IS
      SELECT id, name FROM store ORDER BY id;
   
BEGIN
   
   DBMS_RANDOM.SEED(TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'));
   
   FOR store_rec IN c_stores LOOP
      v_store_id := store_rec.id;
      
      -- GERENTE
      v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_m.COUNT + 1));
      v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
      v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
      v_first_name := v_first_names_m(v_idx1);
      v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
      v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Calle ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 20))) || '-' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(10, 99)));
      INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 1, v_store_id);
      
      -- SUBGERENTE
      v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_f.COUNT + 1));
      v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
      v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
      v_first_name := v_first_names_f(v_idx1);
      v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
      v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Avenida ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 15))) || '-' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(10, 99)));
      INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 2, v_store_id);
      
      -- CAJEROS (3)
      FOR i IN 1..3 LOOP
         v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_f.COUNT + 1));
         v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
         v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
         v_first_name := v_first_names_f(v_idx1);
         v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
         v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Ciudad';
         INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 3, v_store_id);
      END LOOP;
      
      -- SUPERVISORES (2)
      FOR i IN 1..2 LOOP
         v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_m.COUNT + 1));
         v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
         v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
         v_first_name := v_first_names_m(v_idx1);
         v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
         v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Colonia';
         INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 4, v_store_id);
      END LOOP;
      
      -- ALMACÉN (2)
      FOR i IN 1..2 LOOP
         v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_m.COUNT + 1));
         v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
         v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
         v_first_name := v_first_names_m(v_idx1);
         v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
         v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Barrio';
         INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 5, v_store_id);
      END LOOP;
      
      -- CARNICERO
      v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_m.COUNT + 1));
      v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
      v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
      v_first_name := v_first_names_m(v_idx1);
      v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
      v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Residencial';
      INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 6, v_store_id);
      
      -- PANADERO
      v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_m.COUNT + 1));
      v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
      v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
      v_first_name := v_first_names_m(v_idx1);
      v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
      v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Aldea';
      INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 7, v_store_id);
      
      -- LIMPIEZA (2)
      FOR i IN 1..2 LOOP
         v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_f.COUNT + 1));
         v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
         v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
         v_first_name := v_first_names_f(v_idx1);
         v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
         v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Cantón';
         INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 8, v_store_id);
      END LOOP;
      
      -- GUARDIAS (2)
      FOR i IN 1..2 LOOP
         v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_m.COUNT + 1));
         v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
         v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
         v_first_name := v_first_names_m(v_idx1);
         v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
         v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Finca';
         INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 9, v_store_id);
      END LOOP;
      
      -- INVENTARIO
      v_idx1 := TRUNC(DBMS_RANDOM.VALUE(1, v_first_names_m.COUNT + 1));
      v_idx2 := TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1));
      v_idx3 := TRUNC(DBMS_RANDOM.VALUE(1, v_second_last_names.COUNT + 1));
      v_first_name := v_first_names_m(v_idx1);
      v_last_name := v_last_names(v_idx2) || ' ' || v_second_last_names(v_idx3);
      v_address := 'Zona ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13))) || ', Lotificación';
      INSERT INTO employee (first_name, last_name, address, employee_type_id, store_id) VALUES (v_first_name, v_last_name, v_address, 10, v_store_id);
      
      COMMIT;
      
   END LOOP;
   
END;
/
