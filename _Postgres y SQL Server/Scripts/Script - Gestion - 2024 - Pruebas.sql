-- USANDO DataBase gestion_2024:

USE gestion_2024;
------------------------------------------------------------------------

/*
============================================
BASES DE DATOS – PARCIAL 2 - 16/11/2024
============================================
 */

   
 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   2 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 2: Consulta de ventas por sucursal
 Escribir una consulta SQL que muestre el total de ventas por cada sucursal, ordenado de mayor a menor. La
 consulta debe devolver los siguientes datos:
 • código de la sucursal
 • nombre o descripción de la sucursal.
 • nombre de la provincia y nombre de la localidad en la que se encuentra la sucursal. Si la sucursal no
 tiene una localidad asignada, debe mostrar "Provincia desconocida" y "Localidad desconocida"
 • total de ventas
 Las sucursales con mayor facturación 
confirmadas.
 mensual deben aparecer primero.  Considerar únicamente facturas
 La consulta debe implementarse en SQL estándar en una consulta simple, sin el uso de funciones,
 procedimientos, cursores ni otros elementos avanzados.
 */


SELECT s.codigo AS codigo_sucursal,
       s.descripcion AS nombre_sucursal,
       COALESCE(p.descripcion, 'Provincia desconocida') AS provincia,
       COALESCE(l.descripcion, 'Localidad desconocida') AS localidad,
       SUM(f.total) AS total_ventas
 FROM venta.factura AS f
 JOIN persona.empleado AS e ON f.id_empleado = e.id
 JOIN persona.sucursal AS s ON e.id_sucursal = s.id
 LEFT JOIN persona.localidad AS l ON s.id_localidad = l.id
 LEFT JOIN persona.provincia AS p ON l.id_provincia = p.id
 WHERE f.fecha is not null-- WHERE f.fecha_confirmacion is not null
 GROUP BY s.codigo, s.descripcion, p.descripcion, l.descripcion
 ORDER BY total_ventas DESC;



 ------------------------------------------------------------------------- 
 ---------------------- E j e r c i c i o   3 ---------------------------- 
 ------------------------------------------------------------------------.
/*
Ejercicio 3: Vista para DW
 Crear una vista llamada vista_facturacion_dw que permita denormalizar, para su uso en un entorno de data
 warehousing, las tablas factura y factura_detalle. 
Cada fila de esta vista debe representar un detalle de la factura como un evento individual, e incluir las
 siguientes columnas:
 • código del cliente
 • número de la factura
 • año, mes y día de la fecha de facturación
 • total facturado
 • codigo del producto
 • cantidad vendida
 • precio unitario del producto
 • costo del producto
 La vista debe incluir únicamente los datos de ventas realizadas después del año 2021. Considerar únicamente
 facturas confirmadas. Toda esta información debe estar consolidada en una sola fila por cada producto vendido
 en una factura.
 */

CREATE OR REPLACE VIEW vista_facturacion_dw AS
 SELECT 
    c.codigo AS codigo_cliente,
    f.numero AS numero_factura,
    EXTRACT(YEAR FROM f.fecha) AS año,
    EXTRACT(MONTH FROM f.fecha) AS mes,
    EXTRACT(DAY FROM f.fecha) AS dia,
    f.total AS total_facturado,
    p.codigo AS codigo_producto,
    fd.cantidad AS cantidad_vendida,
    fd.precio_unitario AS precio_unitario,
    p.costo_unitario AS costo_producto
 FROM venta.factura AS f
 JOIN persona.cliente AS c ON f.id_cliente = c.id
 JOIN venta.factura_detalle AS fd ON f.id = fd.id_factura
 JOIN producto.producto AS p ON fd.id_producto = p.id
 WHERE EXTRACT(YEAR FROM f.fecha) > 2021
 and f.fecha is not null; --  and f.fecha_confirmacion is not null;



select * from vista_facturacion_dw;












/*
-------------------------------------------------------------------------
-------------------------------------------------------------------------
2. Subqueries 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
*/   