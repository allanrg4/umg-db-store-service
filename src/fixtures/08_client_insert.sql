-- =========================================================
--         Insert de Clientes con nombres aleatorios
-- =========================================================

DECLARE
    v_first_names  SYS.DBMS_DEBUG_VC2COLL := SYS.DBMS_DEBUG_VC2COLL('Luis', 'Ana', 'Carlos', 'María', 'José', 'Sofía', 'Juan', 'Lucía', 'Pedro', 'Camila',
                                                               'Miguel', 'Valentina', 'Jorge', 'Isabella', 'Diego', 'Gabriela', 'Andrés', 'Natalia', 'Fernando', 'Daniela', 'Ricardo', 'Elena', 'Santiago', 'Victoria', 
                                                               'Alberto', 'Paula', 'Rafael', 'Adriana', 'Javier', 'Carolina', 'Héctor', 'Mónica', 'Óscar', 'Lorena', 'Francisco', 'Julieta', 'Ángel', 'Renata', 'Eduardo', 
                                                               'Sara', 'Tomás', 'Diana', 'Sebastián', 'Claudia', 'Bruno', 'Cecilia', 'Gustavo', 'Ariana', 'Iván', 'Luna', 'Mario', 'Elisa','Angel', 'Bianca', 'César', 
                                                               'Fátima', 'Leandro', 'Jimena', 'Pablo', 'Salma', 'Raúl', 'Tania', 'Simón', 'Violeta');

    v_last_names   SYS.DBMS_DEBUG_VC2COLL := SYS.DBMS_DEBUG_VC2COLL('García', 'López', 'Martínez', 'Rodríguez', 'Hernández', 'Pérez', 'Ramírez', 'Flores', 'Gómez', 'Castillo', 'Sánchez', 
                                                              'Torres', 'Rivera', 'Vargas', 'Jiménez', 'Morales', 'Cruz', 'Ortiz', 'Gutiérrez', 'Rojas', 'Mendoza', 'Silva', 'Navarro', 'Domínguez', 
                                                              'Suárez', 'Romero', 'Díaz', 'Álvarez', 'Muñoz', 'Castro', 'Aguilar', 'Cabrera', 'Soto', 'Velásquez', 'Campos', 'Fuentes', 
                                                              'Rivas', 'León', 'Cortés', 'Vega', 'Herrera', 'Peña', 'Molina', 'Salazar', 'Gallardo', 'Ponce', 'Cano', 
                                                              'Mendoza', 'Alvarado', 'Quintanilla', 'Valdez');
v_status       VARCHAR2(50);
v_birthday     DATE;
v_address      VARCHAR2(200);
v_department_id INT;
BEGIN
    FOR i IN 1..500 LOOP
    -- Nombre aleatorio
    DECLARE
        v_fn VARCHAR2(200);
        v_ln VARCHAR2(200);
    BEGIN
        v_fn := v_first_names(TRUNC(DBMS_RANDOM.VALUE(1, v_first_names.COUNT + 1)));
        v_ln := v_last_names(TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1))) || ' ' ||
        v_last_names(TRUNC(DBMS_RANDOM.VALUE(1, v_last_names.COUNT + 1)));

        -- Dirección ficticia
        v_address := 'Zona ' || TRUNC(DBMS_RANDOM.VALUE(1, 25)) || ', Colonia ' || CHR(65 + MOD(i, 26));

        -- Fecha de nacimiento entre 1960 y 2010
        v_birthday := TO_DATE('1960-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 18250)); -- hasta 2010

        -- Estado aleatorio
        v_status := CASE WHEN MOD(i, 10) = 0 THEN 'inactive' ELSE 'active' END;

        -- Departamento aleatorio entre 1 y 22
        v_department_id := TRUNC(DBMS_RANDOM.VALUE(1, 23));

        -- Insertar cliente
        INSERT INTO client (first_name, last_name, address, birthday, status, department_id)
        VALUES (v_fn, v_ln, v_address, v_birthday, v_status, v_department_id);
    END;
END LOOP;
END;
/