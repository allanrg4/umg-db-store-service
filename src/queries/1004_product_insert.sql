-- Abarrotes
INSERT INTO product (name, product_type_id) SELECT 'Arroz Blanco 1 kg', pt.id FROM product_type pt WHERE pt.name='Abarrotes';
INSERT INTO product (name, product_type_id) SELECT 'Frijol Negro 1 lb', pt.id FROM product_type pt WHERE pt.name='Abarrotes';
INSERT INTO product (name, product_type_id) SELECT 'Azúcar 2 lb', pt.id FROM product_type pt WHERE pt.name='Abarrotes';
INSERT INTO product (name, product_type_id) SELECT 'Sal Yodada 500 g', pt.id FROM product_type pt WHERE pt.name='Abarrotes';
INSERT INTO product (name, product_type_id) SELECT 'Aceite Vegetal 1 L', pt.id FROM product_type pt WHERE pt.name='Abarrotes';
INSERT INTO product (name, product_type_id) SELECT 'Pasta Espagueti 400 g', pt.id FROM product_type pt WHERE pt.name='Abarrotes';
INSERT INTO product (name, product_type_id) SELECT 'Sopa Instantánea de Pollo', pt.id FROM product_type pt WHERE pt.name='Abarrotes';
INSERT INTO product (name, product_type_id) SELECT 'Atún en Agua 140 g', pt.id FROM product_type pt WHERE pt.name='Abarrotes';

-- Bebidas
INSERT INTO product (name, product_type_id) SELECT 'Agua Pura 600 ml', pt.id FROM product_type pt WHERE pt.name='Bebidas';
INSERT INTO product (name, product_type_id) SELECT 'Gaseosa Cola 2 L', pt.id FROM product_type pt WHERE pt.name='Bebidas';
INSERT INTO product (name, product_type_id) SELECT 'Jugo de Naranja 1 L', pt.id FROM product_type pt WHERE pt.name='Bebidas';
INSERT INTO product (name, product_type_id) SELECT 'Bebida Isotónica 500 ml', pt.id FROM product_type pt WHERE pt.name='Bebidas';
INSERT INTO product (name, product_type_id) SELECT 'Té Helado 1.5 L', pt.id FROM product_type pt WHERE pt.name='Bebidas';
INSERT INTO product (name, product_type_id) SELECT 'Café Molido 200 g', pt.id FROM product_type pt WHERE pt.name='Bebidas';
INSERT INTO product (name, product_type_id) SELECT 'Cacao en Polvo 300 g', pt.id FROM product_type pt WHERE pt.name='Bebidas';

-- Lácteos
INSERT INTO product (name, product_type_id) SELECT 'Leche Entera 1 L', pt.id FROM product_type pt WHERE pt.name='Lácteos';
INSERT INTO product (name, product_type_id) SELECT 'Leche Deslactosada 1 L', pt.id FROM product_type pt WHERE pt.name='Lácteos';
INSERT INTO product (name, product_type_id) SELECT 'Yogurt Natural 1 L', pt.id FROM product_type pt WHERE pt.name='Lácteos';
INSERT INTO product (name, product_type_id) SELECT 'Queso Fresco 500 g', pt.id FROM product_type pt WHERE pt.name='Lácteos';
INSERT INTO product (name, product_type_id) SELECT 'Crema 250 ml', pt.id FROM product_type pt WHERE pt.name='Lácteos';
INSERT INTO product (name, product_type_id) SELECT 'Mantequilla 200 g', pt.id FROM product_type pt WHERE pt.name='Lácteos';

-- Panadería
INSERT INTO product (name, product_type_id) SELECT 'Pan Francés (6 unidades)', pt.id FROM product_type pt WHERE pt.name='Panadería';
INSERT INTO product (name, product_type_id) SELECT 'Pan Molde Blanco', pt.id FROM product_type pt WHERE pt.name='Panadería';
INSERT INTO product (name, product_type_id) SELECT 'Pan Integral Molde', pt.id FROM product_type pt WHERE pt.name='Panadería';
INSERT INTO product (name, product_type_id) SELECT 'Galletas Saladas 6 pzas', pt.id FROM product_type pt WHERE pt.name='Panadería';
INSERT INTO product (name, product_type_id) SELECT 'Galleta María 1 tubo', pt.id FROM product_type pt WHERE pt.name='Panadería';

-- Carnes y Embutidos
INSERT INTO product (name, product_type_id) SELECT 'Pechuga de Pollo 1 kg', pt.id FROM product_type pt WHERE pt.name='Carnes y Embutidos';
INSERT INTO product (name, product_type_id) SELECT 'Carne Molida de Res 1 lb', pt.id FROM product_type pt WHERE pt.name='Carnes y Embutidos';
INSERT INTO product (name, product_type_id) SELECT 'Chuleta de Cerdo 1 lb', pt.id FROM product_type pt WHERE pt.name='Carnes y Embutidos';
INSERT INTO product (name, product_type_id) SELECT 'Salchicha Tipo Viena 12 u', pt.id FROM product_type pt WHERE pt.name='Carnes y Embutidos';
INSERT INTO product (name, product_type_id) SELECT 'Jamón Cocido 1 lb', pt.id FROM product_type pt WHERE pt.name='Carnes y Embutidos';

-- Frutas y Verduras
INSERT INTO product (name, product_type_id) SELECT 'Banano (manojo)', pt.id FROM product_type pt WHERE pt.name='Frutas y Verduras';
INSERT INTO product (name, product_type_id) SELECT 'Manzana Roja 1 kg', pt.id FROM product_type pt WHERE pt.name='Frutas y Verduras';
INSERT INTO product (name, product_type_id) SELECT 'Aguacate Hass 1 u', pt.id FROM product_type pt WHERE pt.name='Frutas y Verduras';
INSERT INTO product (name, product_type_id) SELECT 'Tomate 1 lb', pt.id FROM product_type pt WHERE pt.name='Frutas y Verduras';
INSERT INTO product (name, product_type_id) SELECT 'Cebolla 1 lb', pt.id FROM product_type pt WHERE pt.name='Frutas y Verduras';
INSERT INTO product (name, product_type_id) SELECT 'Cilantro Manojo', pt.id FROM product_type pt WHERE pt.name='Frutas y Verduras';

-- Congelados
INSERT INTO product (name, product_type_id) SELECT 'Vegetales Mixtos Cong. 500 g', pt.id FROM product_type pt WHERE pt.name='Congelados';
INSERT INTO product (name, product_type_id) SELECT 'Papas a la Francesa 1 kg', pt.id FROM product_type pt WHERE pt.name='Congelados';
INSERT INTO product (name, product_type_id) SELECT 'Helado Vainilla 1 L', pt.id FROM product_type pt WHERE pt.name='Congelados';
INSERT INTO product (name, product_type_id) SELECT 'Nuggets de Pollo 500 g', pt.id FROM product_type pt WHERE pt.name='Congelados';

-- Limpieza del Hogar
INSERT INTO product (name, product_type_id) SELECT 'Detergente en Polvo 1 kg', pt.id FROM product_type pt WHERE pt.name='Limpieza del Hogar';
INSERT INTO product (name, product_type_id) SELECT 'Suavizante 1 L', pt.id FROM product_type pt WHERE pt.name='Limpieza del Hogar';
INSERT INTO product (name, product_type_id) SELECT 'Lavaplatos Líquido 750 ml', pt.id FROM product_type pt WHERE pt.name='Limpieza del Hogar';
INSERT INTO product (name, product_type_id) SELECT 'Cloro 1 L', pt.id FROM product_type pt WHERE pt.name='Limpieza del Hogar';
INSERT INTO product (name, product_type_id) SELECT 'Desinfectante 900 ml', pt.id FROM product_type pt WHERE pt.name='Limpieza del Hogar';
INSERT INTO product (name, product_type_id) SELECT 'Toallas de Cocina 2 rollos', pt.id FROM product_type pt WHERE pt.name='Limpieza del Hogar';

-- Higiene Personal
INSERT INTO product (name, product_type_id) SELECT 'Shampoo 400 ml', pt.id FROM product_type pt WHERE pt.name='Higiene Personal';
INSERT INTO product (name, product_type_id) SELECT 'Jabón de Baño 3 u', pt.id FROM product_type pt WHERE pt.name='Higiene Personal';
INSERT INTO product (name, product_type_id) SELECT 'Pasta Dental 100 ml', pt.id FROM product_type pt WHERE pt.name='Higiene Personal';
INSERT INTO product (name, product_type_id) SELECT 'Cepillo Dental Adulto', pt.id FROM product_type pt WHERE pt.name='Higiene Personal';
INSERT INTO product (name, product_type_id) SELECT 'Desodorante en Barra', pt.id FROM product_type pt WHERE pt.name='Higiene Personal';
INSERT INTO product (name, product_type_id) SELECT 'Papel Higiénico 4 rollos', pt.id FROM product_type pt WHERE pt.name='Higiene Personal';

-- Bebé
INSERT INTO product (name, product_type_id) SELECT 'Pañales Etapa 3 (30 u)', pt.id FROM product_type pt WHERE pt.name='Bebé';
INSERT INTO product (name, product_type_id) SELECT 'Toallitas Húmedas (80 u)', pt.id FROM product_type pt WHERE pt.name='Bebé';
INSERT INTO product (name, product_type_id) SELECT 'Fórmula Infantil 900 g', pt.id FROM product_type pt WHERE pt.name='Bebé';
INSERT INTO product (name, product_type_id) SELECT 'Talco para Bebé 200 g', pt.id FROM product_type pt WHERE pt.name='Bebé';

-- Mascotas
INSERT INTO product (name, product_type_id) SELECT 'Alimento Perro Adulto 4 kg', pt.id FROM product_type pt WHERE pt.name='Mascotas';
INSERT INTO product (name, product_type_id) SELECT 'Alimento Gato 1.5 kg', pt.id FROM product_type pt WHERE pt.name='Mascotas';
INSERT INTO product (name, product_type_id) SELECT 'Arena Sanitaria 10 kg', pt.id FROM product_type pt WHERE pt.name='Mascotas';
INSERT INTO product (name, product_type_id) SELECT 'Collar Antipulgas', pt.id FROM product_type pt WHERE pt.name='Mascotas';

-- Ferretería
INSERT INTO product (name, product_type_id) SELECT 'Foco LED 9W', pt.id FROM product_type pt WHERE pt.name='Ferretería';
INSERT INTO product (name, product_type_id) SELECT 'Cinta Aislante 18 mm', pt.id FROM product_type pt WHERE pt.name='Ferretería';
INSERT INTO product (name, product_type_id) SELECT 'Martillo Carpintero', pt.id FROM product_type pt WHERE pt.name='Ferretería';
INSERT INTO product (name, product_type_id) SELECT 'Clavos 2" (bolsa)', pt.id FROM product_type pt WHERE pt.name='Ferretería';
INSERT INTO product (name, product_type_id) SELECT 'Destornillador Plano', pt.id FROM product_type pt WHERE pt.name='Ferretería';

-- Electrónica
INSERT INTO product (name, product_type_id) SELECT 'Audífonos Inalámbricos', pt.id FROM product_type pt WHERE pt.name='Electrónica';
INSERT INTO product (name, product_type_id) SELECT 'Cargador USB Doble', pt.id FROM product_type pt WHERE pt.name='Electrónica';
INSERT INTO product (name, product_type_id) SELECT 'Cable HDMI 2 m', pt.id FROM product_type pt WHERE pt.name='Electrónica';
INSERT INTO product (name, product_type_id) SELECT 'Power Bank 10,000 mAh', pt.id FROM product_type pt WHERE pt.name='Electrónica';
INSERT INTO product (name, product_type_id) SELECT 'Mouse Óptico USB', pt.id FROM product_type pt WHERE pt.name='Electrónica';

-- Electrodomésticos
INSERT INTO product (name, product_type_id) SELECT 'Licuadora 1.5 L', pt.id FROM product_type pt WHERE pt.name='Electrodomésticos';
INSERT INTO product (name, product_type_id) SELECT 'Tostadora 2 Rebanadas', pt.id FROM product_type pt WHERE pt.name='Electrodomésticos';
INSERT INTO product (name, product_type_id) SELECT 'Plancha de Ropa', pt.id FROM product_type pt WHERE pt.name='Electrodomésticos';
INSERT INTO product (name, product_type_id) SELECT 'Horno Eléctrico 30 L', pt.id FROM product_type pt WHERE pt.name='Electrodomésticos';

-- Papelería
INSERT INTO product (name, product_type_id) SELECT 'Cuaderno Universitario 100 h', pt.id FROM product_type pt WHERE pt.name='Papelería';
INSERT INTO product (name, product_type_id) SELECT 'Lápiz de Grafito HB', pt.id FROM product_type pt WHERE pt.name='Papelería';
INSERT INTO product (name, product_type_id) SELECT 'Borrador Blanco', pt.id FROM product_type pt WHERE pt.name='Papelería';
INSERT INTO product (name, product_type_id) SELECT 'Marcadores Permanentes (4 u)', pt.id FROM product_type pt WHERE pt.name='Papelería';
INSERT INTO product (name, product_type_id) SELECT 'Resaltadores (4 u)', pt.id FROM product_type pt WHERE pt.name='Papelería';

-- Juguetes
INSERT INTO product (name, product_type_id) SELECT 'Pelota de Goma', pt.id FROM product_type pt WHERE pt.name='Juguetes';
INSERT INTO product (name, product_type_id) SELECT 'Muñeca Clásica', pt.id FROM product_type pt WHERE pt.name='Juguetes';
INSERT INTO product (name, product_type_id) SELECT 'Carro de Juguete Metálico', pt.id FROM product_type pt WHERE pt.name='Juguetes';
INSERT INTO product (name, product_type_id) SELECT 'Bloques de Construcción 100 pzs', pt.id FROM product_type pt WHERE pt.name='Juguetes';
INSERT INTO product (name, product_type_id) SELECT 'Rompecabezas 200 pzs', pt.id FROM product_type pt WHERE pt.name='Juguetes';

-- Ropa Hombre
INSERT INTO product (name, product_type_id) SELECT 'Camiseta Hombre Talla M', pt.id FROM product_type pt WHERE pt.name='Ropa Hombre';
INSERT INTO product (name, product_type_id) SELECT 'Camisa Manga Larga Hombre', pt.id FROM product_type pt WHERE pt.name='Ropa Hombre';
INSERT INTO product (name, product_type_id) SELECT 'Pantalón Jeans Hombre', pt.id FROM product_type pt WHERE pt.name='Ropa Hombre';
INSERT INTO product (name, product_type_id) SELECT 'Chumpa Ligera Hombre', pt.id FROM product_type pt WHERE pt.name='Ropa Hombre';
INSERT INTO product (name, product_type_id) SELECT 'Calcetines Hombre (3 pares)', pt.id FROM product_type pt WHERE pt.name='Ropa Hombre';

-- Ropa Mujer
INSERT INTO product (name, product_type_id) SELECT 'Blusa Mujer Talla M', pt.id FROM product_type pt WHERE pt.name='Ropa Mujer';
INSERT INTO product (name, product_type_id) SELECT 'Pantalón Jeans Mujer', pt.id FROM product_type pt WHERE pt.name='Ropa Mujer';
INSERT INTO product (name, product_type_id) SELECT 'Leggings Deportivos Mujer', pt.id FROM product_type pt WHERE pt.name='Ropa Mujer';
INSERT INTO product (name, product_type_id) SELECT 'Suéter Ligero Mujer', pt.id FROM product_type pt WHERE pt.name='Ropa Mujer';
INSERT INTO product (name, product_type_id) SELECT 'Calcetas Mujer (3 pares)', pt.id FROM product_type pt WHERE pt.name='Ropa Mujer';

-- Ropa Niño
INSERT INTO product (name, product_type_id) SELECT 'Playera Niño Talla 6', pt.id FROM product_type pt WHERE pt.name='Ropa Niño';
INSERT INTO product (name, product_type_id) SELECT 'Pantalón Niño Talla 6', pt.id FROM product_type pt WHERE pt.name='Ropa Niño';
INSERT INTO product (name, product_type_id) SELECT 'Sudadera Niño', pt.id FROM product_type pt WHERE pt.name='Ropa Niño';
INSERT INTO product (name, product_type_id) SELECT 'Conjunto Niño (2 pzas)', pt.id FROM product_type pt WHERE pt.name='Ropa Niño';

-- Calzado
INSERT INTO product (name, product_type_id) SELECT 'Tenis Casual Hombre', pt.id FROM product_type pt WHERE pt.name='Calzado';
INSERT INTO product (name, product_type_id) SELECT 'Tenis Deportivo Mujer', pt.id FROM product_type pt WHERE pt.name='Calzado';
INSERT INTO product (name, product_type_id) SELECT 'Sandalias Unisex', pt.id FROM product_type pt WHERE pt.name='Calzado';
INSERT INTO product (name, product_type_id) SELECT 'Zapatos Escolares Niño', pt.id FROM product_type pt WHERE pt.name='Calzado';

-- Deportes
INSERT INTO product (name, product_type_id) SELECT 'Balón de Fútbol No. 5', pt.id FROM product_type pt WHERE pt.name='Deportes';
INSERT INTO product (name, product_type_id) SELECT 'Balón de Baloncesto', pt.id FROM product_type pt WHERE pt.name='Deportes';
INSERT INTO product (name, product_type_id) SELECT 'Cuerda para Saltar', pt.id FROM product_type pt WHERE pt.name='Deportes';
INSERT INTO product (name, product_type_id) SELECT 'Mancuernas 2 kg (par)', pt.id FROM product_type pt WHERE pt.name='Deportes';

-- Automotriz
INSERT INTO product (name, product_type_id) SELECT 'Aceite de Motor 10W-30 1 L', pt.id FROM product_type pt WHERE pt.name='Automotriz';
INSERT INTO product (name, product_type_id) SELECT 'Líquido Limpiaparabrisas 1 L', pt.id FROM product_type pt WHERE pt.name='Automotriz';
INSERT INTO product (name, product_type_id) SELECT 'Ambientador para Auto', pt.id FROM product_type pt WHERE pt.name='Automotriz';
INSERT INTO product (name, product_type_id) SELECT 'Cables de Batería', pt.id FROM product_type pt WHERE pt.name='Automotriz';

-- Hogar y Decoración
INSERT INTO product (name, product_type_id) SELECT 'Juego de Sábanas Matrimonial', pt.id FROM product_type pt WHERE pt.name='Hogar y Decoración';
INSERT INTO product (name, product_type_id) SELECT 'Cortinas Blackout 2 pzas', pt.id FROM product_type pt WHERE pt.name='Hogar y Decoración';
INSERT INTO product (name, product_type_id) SELECT 'Cojines Decorativos (2 u)', pt.id FROM product_type pt WHERE pt.name='Hogar y Decoración';
INSERT INTO product (name, product_type_id) SELECT 'Reloj de Pared', pt.id FROM product_type pt WHERE pt.name='Hogar y Decoración';

-- Jardinería
INSERT INTO product (name, product_type_id) SELECT 'Tierra para Macetas 10 kg', pt.id FROM product_type pt WHERE pt.name='Jardinería';
INSERT INTO product (name, product_type_id) SELECT 'Abono Orgánico 5 kg', pt.id FROM product_type pt WHERE pt.name='Jardinería';
INSERT INTO product (name, product_type_id) SELECT 'Regadera Plástica', pt.id FROM product_type pt WHERE pt.name='Jardinería';
INSERT INTO product (name, product_type_id) SELECT 'Manguera 15 m', pt.id FROM product_type pt WHERE pt.name='Jardinería';

select * from product;