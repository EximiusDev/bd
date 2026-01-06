-- 
-- Base de datos Sistema de Gestión en SQL Server
--

-- Esquemas
CREATE SCHEMA persona;
CREATE SCHEMA producto;
CREATE SCHEMA venta;

-- 
-- Secuencias (una por cada esquema)
-- Ojo: si se usa SQL Server 20008 no soporta secuencias
--CREATE SEQUENCE persona.persona_sequence START WITH 1 INCREMENT BY 1;
--CREATE SEQUENCE producto.producto_sequence START WITH 1 INCREMENT BY 1;
--CREATE SEQUENCE venta.venta_sequence START WITH 1 INCREMENT BY 1;

-- 
-- Tablas del esquema persona
--

CREATE TABLE persona.provincia (
    id bigint NOT NULL,
    version int NOT NULL,
    codigo int NOT NULL,
    descripcion varchar(50) NOT NULL,
    CONSTRAINT provincia_pk PRIMARY KEY (id),
    CONSTRAINT provincia_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE persona.localidad (
    id bigint NOT NULL,
    version int NOT NULL,
    id_provincia bigint NOT NULL,
    codigo int NOT NULL,
    descripcion varchar(50) NOT NULL,
    codigo_postal int,
    CONSTRAINT localidad_pk PRIMARY KEY (id),
    CONSTRAINT localidad_codigo_ipk UNIQUE (id_provincia, codigo),
    CONSTRAINT localidad_provincia_fk FOREIGN KEY (id_provincia) REFERENCES persona.provincia (id)
);

CREATE TABLE persona.sucursal (
    id bigint NOT NULL,
    version int NOT NULL,
    codigo int NOT NULL,
    descripcion varchar(50) NOT NULL,
    domicilio varchar(255),
    id_localidad bigint,
    CONSTRAINT sucursal_pk PRIMARY KEY (id),
    CONSTRAINT sucursal_codigo_ipk UNIQUE (codigo),
    CONSTRAINT sucursal_localidad_fk FOREIGN KEY (id_localidad) REFERENCES persona.localidad (id)
);

CREATE TABLE persona.persona (
    id bigint NOT NULL,
    version int NOT NULL,
    tipo varchar(10) NOT NULL,
    codigo int NOT NULL,
    fecha_alta datetime NOT NULL,
    email varchar(255),
    observaciones varchar(255),
    foto_perfil varbinary(max),
    domicilio varchar(255),
    id_localidad bigint,
    CONSTRAINT persona_pk PRIMARY KEY (id),
    CONSTRAINT persona_codigo_ipk UNIQUE (tipo, codigo),
    CONSTRAINT persona_localidad_fk FOREIGN KEY (id_localidad) REFERENCES persona.localidad (id)
);

CREATE TABLE persona.persona_fisica (
    id bigint NOT NULL,
    version int NOT NULL,
    id_persona bigint NOT NULL,
    tipo_documento varchar(10) NOT NULL,
    numero_documento int NOT NULL,
    cuil varchar(11),
    fecha_nacimiento date NOT NULL,
    apellido varchar(255) NOT NULL,
    nombre varchar(255) NOT NULL,
    genero varchar(50) NOT NULL,
    estado_civil varchar(50) NOT NULL,
    grupo_familiar varchar(50) NOT NULL,
    nivel_educativo varchar(50) NOT NULL,
    rango_ingresos varchar(50) NOT NULL,
    tipo_alojamiento varchar(50) NOT NULL,
    CONSTRAINT persona_fisica_pk PRIMARY KEY (id),
    CONSTRAINT persona_fisica_documento_ipk UNIQUE (tipo_documento, numero_documento),
    CONSTRAINT persona_fisica_ipk UNIQUE (id_persona),
    CONSTRAINT persona_fisica_persona_fk FOREIGN KEY (id_persona) REFERENCES persona.persona (id),
    -- CONSTRAINT persona_fisica_cuil_ipk UNIQUE (cuil), Se elimina para facilitar carga de datos
    CONSTRAINT persona_fisica_genero_chk CHECK (genero IN ('MASCULINO', 'FEMENINO')),
    CONSTRAINT persona_fisica_estado_civil_chk CHECK (estado_civil IN ('SOLTERO', 'CASADO', 'PREVIAMENTE CASADO', 'NO_INFORMADO')),
    CONSTRAINT persona_fisica_grupo_familiar_chk CHECK (grupo_familiar IN ('1', '2', '3', '4', '5', '6', 'Más de 6')),
    CONSTRAINT persona_fisica_nivel_educativo_chk CHECK (nivel_educativo IN ('SECUNDARIO', 'UNIVERSITARIO', 'POSTGRADO', 'OTRO')),
    CONSTRAINT cliente_rango_ingresos_chk CHECK (rango_ingresos IN ('Menos de 50.000', '50.000 - 100.000', '100.000 - 150.000', '150.000 - 200.000', '250.000 - 300.000', '300.000 - 350.000', '350.000 - 400.000', '400.000 - 450.000', '450.000 - 500.000', 'Más de 500.000')),
    CONSTRAINT cliente_tipo_alojamiento_chk CHECK (tipo_alojamiento IN ('INQUILINO', 'PROPIETARIO', 'DEPENDIENTE', 'NO_INFORMADO'))
);

CREATE TABLE persona.persona_juridica (
    id bigint NOT NULL,
    version int NOT NULL,
    id_persona bigint NOT NULL,
    cuit varchar(11) NOT NULL,
    denominacion varchar(255) NOT NULL,
    CONSTRAINT persona_juridica_pk PRIMARY KEY (id),
    CONSTRAINT persona_juridica_ipk UNIQUE (id_persona),
    CONSTRAINT persona_juridica_persona_fk FOREIGN KEY (id_persona) REFERENCES persona.persona (id),
    CONSTRAINT persona_juridica_cuit_ipk UNIQUE (cuit)
);

CREATE TABLE persona.cliente (
    id bigint NOT NULL,
    version int NOT NULL,
    id_persona bigint NOT NULL,
    codigo int NOT NULL,
    fecha_alta datetime NOT NULL,
    CONSTRAINT cliente_pk PRIMARY KEY (id),
    CONSTRAINT cliente_persona_ipk UNIQUE (id_persona),
    CONSTRAINT cliente_codigo_ipk UNIQUE (codigo),
    CONSTRAINT cliente_persona_fk FOREIGN KEY (id_persona) REFERENCES persona.persona (id)
);

CREATE TABLE persona.empleado (
    id bigint NOT NULL,
    version int NOT NULL,
    id_persona_fisica bigint NOT NULL,
    codigo int NOT NULL,
    fecha_alta datetime NOT NULL,
    id_sucursal bigint NOT NULL,
    CONSTRAINT empleado_pk PRIMARY KEY (id),
    CONSTRAINT empleado_persona_ipk UNIQUE (id_persona_fisica),
    CONSTRAINT empleado_codigo_ipk UNIQUE (codigo),
    CONSTRAINT empleado_persona_fk FOREIGN KEY (id_persona_fisica) REFERENCES persona.persona_fisica (id),
    CONSTRAINT empleado_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES persona.sucursal (id)
);

CREATE TABLE persona.proveedor (
    id bigint NOT NULL,
    version int NOT NULL,
    id_persona_juridica bigint NOT NULL,
    codigo int NOT NULL,
    fecha_alta datetime NOT NULL,
    CONSTRAINT proveedor_pk PRIMARY KEY (id),
    CONSTRAINT proveedor_persona_ipk UNIQUE (id_persona_juridica),
    CONSTRAINT proveedor_codigo_ipk UNIQUE (codigo),
    CONSTRAINT proveedor_persona_fk FOREIGN KEY (id_persona_juridica) REFERENCES persona.persona_juridica (id)
);

-- 
-- Tablas del esquema producto
--

CREATE TABLE producto.categoria (
    id bigint NOT NULL,
    version int NOT NULL,
    codigo int NOT NULL,
    descripcion varchar(50) NOT NULL,
    CONSTRAINT categoria_pk PRIMARY KEY (id),
    CONSTRAINT categoria_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE producto.subcategoria (
    id bigint NOT NULL,
    version int NOT NULL,
    id_categoria bigint NOT NULL,
    codigo int NOT NULL,
    descripcion varchar(50) NOT NULL,
    CONSTRAINT subcategoria_pk PRIMARY KEY (id),
    CONSTRAINT subcategoria_codigo_ipk UNIQUE (id_categoria, codigo),
    CONSTRAINT subcategoria_categoria_fk FOREIGN KEY (id_categoria) REFERENCES producto.categoria (id)
);

CREATE TABLE producto.marca (
    id bigint NOT NULL,
    version int NOT NULL,
    codigo int NOT NULL,
    descripcion varchar(50) NOT NULL,
    CONSTRAINT marca_pk PRIMARY KEY (id),
    CONSTRAINT marca_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE producto.producto (
    id bigint NOT NULL,
    version int NOT NULL,
    codigo int NOT NULL,
    descripcion varchar(50) NOT NULL,
    precio_unitario numeric(38,2) NOT NULL,
    costo_unitario numeric(38,2) NOT NULL,
    id_subcategoria bigint,
    id_proveedor bigint,
    id_marca bigint,
    CONSTRAINT producto_pk PRIMARY KEY (id),
    CONSTRAINT producto_codigo_ipk UNIQUE (codigo),
    CONSTRAINT producto_subcategoria_fk FOREIGN KEY (id_subcategoria) REFERENCES producto.subcategoria (id),
    CONSTRAINT producto_proveedor_fk FOREIGN KEY (id_proveedor) REFERENCES persona.proveedor (id),
    CONSTRAINT producto_marca_fk FOREIGN KEY (id_marca) REFERENCES producto.marca (id)
);

-- 
-- Tablas del esquema venta
--

CREATE TABLE venta.promocion (
    id bigint NOT NULL,
    version int NOT NULL,
    codigo int NOT NULL,
    descripcion varchar(50) NOT NULL,
    porcentaje_descuento numeric,
    CONSTRAINT promocion_pk PRIMARY KEY (id),
    CONSTRAINT promocion_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE venta.forma_pago (
    id bigint NOT NULL,
    version int NOT NULL,
    codigo int NOT NULL,
    descripcion varchar(50) NOT NULL,
    porcentaje_descuento numeric NOT NULL,
    CONSTRAINT forma_pago_pk PRIMARY KEY (id),
    CONSTRAINT forma_pago_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE venta.factura (
    id bigint NOT NULL,
    version int NOT NULL,
    numero int NOT NULL,
    id_cliente bigint NOT NULL,
    id_empleado bigint NOT NULL,
    id_promocion bigint,
    id_forma_pago bigint,
    fecha date NOT NULL,
    descuento numeric(38,2) NOT NULL,
    total numeric(38,2) NOT NULL,
    CONSTRAINT factura_pk PRIMARY KEY (id),
    CONSTRAINT factura_numero_ipk UNIQUE (numero),
    CONSTRAINT factura_cliente_fk FOREIGN KEY (id_cliente) REFERENCES persona.cliente (id),
    CONSTRAINT factura_empleado_fk FOREIGN KEY (id_empleado) REFERENCES persona.empleado (id),
    CONSTRAINT factura_promocion_fk FOREIGN KEY (id_promocion) REFERENCES venta.promocion (id),
    CONSTRAINT factura_forma_pago_fk FOREIGN KEY (id_forma_pago) REFERENCES venta.forma_pago (id)
);

CREATE TABLE venta.factura_detalle (
    id bigint NOT NULL,
    version int NOT NULL,
    id_factura bigint NOT NULL,
    item int NOT NULL,
    id_producto bigint NOT NULL,
    cantidad numeric(38,2) NOT NULL,
    precio_unitario numeric(38,2) NOT NULL,
    CONSTRAINT factura_detalle_pk PRIMARY KEY (id),
    CONSTRAINT factura_item_ipk UNIQUE (id_factura, item),
    CONSTRAINT factura_detalle_factura_fk FOREIGN KEY (id_factura) REFERENCES venta.factura (id),
    CONSTRAINT factura_detalle_producto_fk FOREIGN KEY (id_producto) REFERENCES producto.producto (id)
);

--  select count(*) from venta.factura_detalle fd 
--  select * from venta.factura_detalle fd 