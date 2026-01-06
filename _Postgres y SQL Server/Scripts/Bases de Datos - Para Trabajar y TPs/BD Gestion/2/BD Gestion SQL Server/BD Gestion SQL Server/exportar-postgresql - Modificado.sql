-- Script para exportar los datos de PostgreSQL a archivos CSV

/*
 SI NO ANDA EL SCRIPT
 SE NECESITA CREAR LA CARPETA C:/tmp en el disco
 Sino ver los "/" para que queden asi: C:\tmp
*/

-- Exportar datos del esquema persona
COPY persona.provincia TO 'C:/tmp/provincia.csv' DELIMITER ',' CSV HEADER;
COPY persona.localidad TO 'C:/tmp/localidad.csv' DELIMITER ',' CSV HEADER;
COPY persona.sucursal TO 'C:/tmp/sucursal.csv' DELIMITER ',' CSV HEADER;
COPY persona.persona TO 'C:/tmp/persona.csv' DELIMITER ',' CSV HEADER;
COPY persona.persona_fisica TO 'C:/tmp/persona_fisica.csv' DELIMITER ',' CSV HEADER;
COPY persona.persona_juridica TO 'C:/tmp/persona_juridica.csv' DELIMITER ',' CSV HEADER;
COPY persona.cliente TO 'C:/tmp/cliente.csv' DELIMITER ',' CSV HEADER;
COPY persona.empleado TO 'C:/tmp/empleado.csv' DELIMITER ',' CSV HEADER;
COPY persona.proveedor TO 'C:/tmp/proveedor.csv' DELIMITER ',' CSV HEADER;

-- Exportar datos del esquema producto
COPY producto.categoria TO 'C:/tmp/categoria.csv' DELIMITER ',' CSV HEADER;
COPY producto.subcategoria TO 'C:/tmp/subcategoria.csv' DELIMITER ',' CSV HEADER;
COPY producto.marca TO 'C:/tmp/marca.csv' DELIMITER ',' CSV HEADER;
COPY producto.producto TO 'C:/tmp/producto.csv' DELIMITER ',' CSV HEADER;

-- Exportar datos del esquema venta
COPY venta.promocion TO 'C:/tmp/promocion.csv' DELIMITER ',' CSV HEADER;
COPY venta.forma_pago TO 'C:/tmp/forma_pago.csv' DELIMITER ',' CSV HEADER;
COPY venta.factura TO 'C:/tmp/factura.csv' DELIMITER ',' CSV HEADER;
COPY venta.factura_detalle TO 'C:/tmp/factura_detalle.csv' DELIMITER ',' CSV HEADER;
