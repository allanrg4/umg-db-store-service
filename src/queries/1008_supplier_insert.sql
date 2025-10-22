-- =============================================
--                Proveedores 
-- =============================================

-- Proovedor de Abarrotes, Frutas y verduras
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Distribuidora La bendicón', 'Zona 1, El Progreso', 'active', 5);
-- Proovedor de Bebidas
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Bebidas S.A', 'Ingenio Zacapa', 'active', 22);
-- Proovedor de Productos Lacteos
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Granja La super Leche', 'Zona 2, Huehuetenango', 'active', 8);
-- Proovedor para panaderia carnes y embutidos
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Alimentos y mas', 'Zona 3, Quetzaltenango', 'active', 12);
-- Proovedor de productos de limpieza del hogar
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Distribuciones El Amigo', 'Zona 1, Escuintla', 'active', 17);
-- Proovedor de productos congelados
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Frios S.A', 'Zona 4, Baja Verapaz', 'active', 2);
-- Proovedor de productos de higiene personal
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('LimpiaMas', 'Zona 5, Peten', 'active', 21);
-- Proovedor de productos para bebés
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('BabyHealth', 'Zona 6, Guatemala', 'active', 7);
-- Proovedor de electronica y electrodomesticos
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Tecnologia y mas', 'Zona 7, Mixco', 'active', 7);
-- Proovedor de materiales de construccion (Ferreteria)
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Construcciones El Fuerte', 'Zona 8, El Progreso', 'active', 5);
-- Proovedor de productos para mascotas
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Mascotas S.A', 'Zona 9, Guatemala', 'active', 7);
-- Proovedor de productos de papeleria y oficina
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('OfiPlus', 'Calle Ancha Antigua Guatemala', 'active', 16);
-- Proovedor de ropa y calzado (Hombre, Mujer, Niños, calzado y deportes)
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('De todo un Poco', 'Zona 10, Escuintla', 'active', 6);
-- Proovedor de productos de jardineria y agricultura
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Jardineria y Mas', 'Zona 11, Guatemala', 'active', 7);
-- Proovedor de productos de automotriz
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('AutoPartes S.A', 'Zona 12, Guatemala', 'active', 7);
-- Proovedor de productos de hogar y decoracion
INSERT INTO supplier (company_name, address, status, department_id)
VALUES ('Hogar y Mas', 'Zona 13, Guatemala', 'active', 7);

-- ===========================================
--             Product - Supplier
-- ===========================================

-- Asignar productos al proveedor de Abarrotes, Frutas y Verduras
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 1, id, 10.00
FROM product
WHERE product_type_id IN (1, 6);

-- Asignar productos al proveedor de Bebidas
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 2, id, 4.00
FROM product
WHERE product_type_id IN (2);

-- Asignar productos al proveedor de Productos Lacteos
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 3, id, 8.75
FROM product
WHERE product_type_id IN (3);

-- Asignar productos al proveedor de Panaderia, Carnes y Embutidos
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 4, id, 5.20
FROM product
WHERE product_type_id IN (4);

INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 4, id, 6.32
FROM product
WHERE product_type_id IN (5);

-- Asignar productos al proveedor de Productos de Limpieza del Hogar
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 5, id, 15.50
FROM product
WHERE product_type_id IN (8);

-- Asignar productos al proveedor de Productos Congelados
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 6, id, 13.60
FROM product
WHERE product_type_id IN (7);

-- Asignar productos al proveedor de Productos de Higiene Personal
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 7, id, 9.80
FROM product
WHERE product_type_id IN (9);

-- Asignar productos al proveedor de Productos para Bebés
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 8, id, 20.00
FROM product
WHERE product_type_id IN (10);

-- Asignar productos al proveedor de Electronica y Electrodomesticos
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 9, id, 56.00
FROM product
WHERE product_type_id IN (13);

INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 9, id, 100.00
FROM product
WHERE product_type_id IN (14);

-- Asignar productos al proveedor de Materiales de Construccion (Ferreteria)
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 10, id, 11.25
FROM product
WHERE product_type_id IN (12);

-- Asignar productos al proveedor de Productos para Mascotas
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 11, id, 18.00
FROM product
WHERE product_type_id IN (11);

-- Asignar productos al proveedor de Productos de Papeleria y Oficina
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 12, id, 5.00
FROM product
WHERE product_type_id IN (15);

-- Asignar productos al proveedor de Ropa y Calzado (Hombre, Mujer, Niños, Calzado y Deportes)
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 13, id, 16.00
FROM product
WHERE product_type_id IN (16, 21);

INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 13, id, 10.00
FROM product
WHERE product_type_id IN (17, 18, 19, 20);

-- Asignar productos al proveedor de Productos de Jardineria y Agricultura
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 14, id, 8.00
FROM product
WHERE product_type_id IN (24);

-- Asignar productos al proveedor de Productos de Automotriz
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 15, id, 30.00
FROM product
WHERE product_type_id IN (22);

-- Asignar productos al proveedor de Productos de Hogar y Decoracion
INSERT INTO supplier_product (supplier_id, product_id, price)
SELECT 16, id, 25.00
FROM product
WHERE product_type_id IN (23);

select * from supplier_product;
