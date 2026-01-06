-- Script para importar los datos desde archivos CSV en SQL Server

-- Importar datos en el esquema persona
BULK INSERT persona.provincia
FROM 'C:\tmp\provincia.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2 -- Omite la primera fila de encabezados
);

BULK INSERT persona.localidad
FROM 'C:\tmp\localidad.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT persona.sucursal
FROM 'C:\tmp\sucursal.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT persona.persona
FROM 'C:\tmp\persona.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT persona.persona_fisica
FROM 'C:\tmp\persona_fisica.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT persona.persona_juridica
FROM 'C:\tmp\persona_juridica.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT persona.cliente
FROM 'C:\tmp\cliente.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT persona.empleado
FROM 'C:\tmp\empleado.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT persona.proveedor
FROM 'C:\tmp\proveedor.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- Importar datos en el esquema producto
BULK INSERT producto.categoria
FROM 'C:\tmp\categoria.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT producto.subcategoria
FROM 'C:\tmp\subcategoria.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT producto.marca
FROM 'C:\tmp\marca.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT producto.producto
FROM 'C:\tmp\producto.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- Importar datos en el esquema venta
BULK INSERT venta.promocion
FROM 'C:\tmp\promocion.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT venta.forma_pago
FROM 'C:\tmp\forma_pago.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT venta.factura
FROM 'C:\tmp\factura.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT venta.factura_detalle
FROM 'C:\tmp\factura_detalle.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);



-- select count(*) from venta.factura_detalle fd 

-- select * from venta.factura_detalle fd 
