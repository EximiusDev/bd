--
-- Base de datos Sistema de Gestión
--

-- Esquemas
--
CREATE SCHEMA persona;
CREATE SCHEMA producto;
CREATE SCHEMA venta;

--
-- Secuencias
--
CREATE SEQUENCE persona.persona_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE producto.producto_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE venta.venta_sequence START WITH 1 INCREMENT BY 1;

--
-- Tablas del esquema persona
--

CREATE TABLE persona.provincia (
    id bigint NOT NULL,
	version integer NOT NULL,
	codigo integer NOT NULL,
    descripcion character varying(50) NOT NULL,
	CONSTRAINT provincia_pk PRIMARY KEY (id),
	CONSTRAINT provincia_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE persona.localidad (
    id bigint NOT NULL,
	version integer NOT NULL,
	id_provincia bigint NOT NULL,
	codigo integer NOT NULL,
    descripcion character varying(50) NOT NULL,
	codigo_postal integer,
	CONSTRAINT localidad_pk PRIMARY KEY (id),
	CONSTRAINT localidad_codigo_ipk UNIQUE (id_provincia, codigo),
	CONSTRAINT localidad_provincia_fk FOREIGN KEY (id_provincia) REFERENCES persona.provincia (id)
);

CREATE TABLE persona.sucursal (
    id bigint NOT NULL,
	version integer NOT NULL,
	codigo integer NOT NULL,
    descripcion character varying(50) NOT NULL,
	domicilio character varying(255),
	id_localidad bigint,
	CONSTRAINT sucursal_pk PRIMARY KEY (id),
	CONSTRAINT sucursal_codigo_ipk UNIQUE (codigo),
	CONSTRAINT sucursal_localidad_fk FOREIGN KEY (id_localidad) REFERENCES persona.localidad (id)
);

CREATE TABLE persona.persona (
    id bigint NOT NULL,
	version integer NOT NULL,
	tipo character varying(10) NOT NULL,
    codigo integer NOT NULL,
    fecha_alta timestamp(6) without time zone NOT NULL,
    email character varying(255),
	observaciones character varying(255),
    foto_perfil bytea,
	domicilio character varying(255),
	id_localidad bigint,
	CONSTRAINT persona_pk PRIMARY KEY (id),
	CONSTRAINT persona_codigo_ipk UNIQUE (tipo, codigo),
	CONSTRAINT persona_tipo_chk CHECK (tipo::text = ANY (ARRAY['FISICA'::character varying, 'JURIDICA'::character varying]::text[])),
	CONSTRAINT persona_localidad_fk FOREIGN KEY (id_localidad) REFERENCES persona.localidad (id)
);

CREATE TABLE persona.persona_fisica (
    id bigint NOT NULL,
	version integer NOT NULL,
	id_persona bigint NOT NULL,
	tipo_documento character varying(10) NOT NULL,
    numero_documento integer NOT NULL,
	cuil character varying(11),
    fecha_nacimiento date NOT NULL,
    apellido character varying(255) NOT NULL,
	nombre character varying(255) NOT NULL,
    genero character varying(50) NOT NULL,
	estado_civil character varying(50) NOT NULL,
	grupo_familiar character varying(50) NOT NULL,
    nivel_educativo character varying(50) NOT NULL,
    rango_ingresos character varying(50) NOT NULL,
    tipo_alojamiento character varying(50) NOT NULL,
	CONSTRAINT persona_fisica_pk PRIMARY KEY (id),
    CONSTRAINT persona_fisica_documento_ipk UNIQUE (tipo_documento, numero_documento),
	CONSTRAINT persona_fisica_ipk UNIQUE (id_persona),
	CONSTRAINT persona_fisica_persona_fk FOREIGN KEY (id_persona) REFERENCES persona.persona (id),
	CONSTRAINT persona_fisica_cuil_ipk UNIQUE (cuil),
    CONSTRAINT persona_fisica_tipo_documento_chk CHECK (tipo_documento::text = ANY (ARRAY['DNI'::character varying, 'LC'::character varying, 'LE'::character varying, 'PAS'::character varying]::text[])),
    CONSTRAINT persona_fisica_genero_chk CHECK (((genero)::text = ANY (ARRAY[('MASCULINO'::character varying)::text, ('FEMENINO'::character varying)::text]))),
    CONSTRAINT persona_fisica_estado_civil_chk CHECK (((estado_civil)::text = ANY (ARRAY[('SOLTERO'::character varying)::text, ('CASADO'::character varying)::text, ('PREVIAMENTE CASADO'::character varying)::text, ('NO_INFORMADO'::character varying)::text]))),
    CONSTRAINT persona_fisica_grupo_familiar_chk CHECK (((grupo_familiar)::text = ANY (ARRAY[('1'::character varying)::text, ('2'::character varying)::text, ('3'::character varying)::text, ('4'::character varying)::text, ('5'::character varying)::text, ('6'::character varying)::text, ('Más de 6'::character varying)::text]))),
    CONSTRAINT persona_fisica_nivel_educativo_chk CHECK (((nivel_educativo)::text = ANY (ARRAY[('SECUNDARIO'::character varying)::text, ('UNIVERSITARIO'::character varying)::text, ('POSTGRADO'::character varying)::text, ('OTRO'::character varying)::text]))),
    CONSTRAINT cliente_rango_ingresos_chk CHECK (((rango_ingresos)::text = ANY (ARRAY[('Menos de 50.000'::character varying)::text, ('50.000 - 100.000'::character varying)::text, ('100.000 - 150.000'::character varying)::text, ('150.000 - 200.000'::character varying)::text, ('250.000 - 300.000'::character varying)::text, ('300.000 - 350.000'::character varying)::text, ('350.000 - 400.000'::character varying)::text, ('400.000 - 450.000'::character varying)::text, ('450.000 - 500.000'::character varying)::text, ('Más de 500.000'::character varying)::text]))),
    CONSTRAINT cliente_tipo_alojamiento_chk CHECK (((tipo_alojamiento)::text = ANY (ARRAY[('INQUILINO'::character varying)::text, ('PROPIETARIO'::character varying)::text, ('DEPENDIENTE'::character varying)::text, ('NO_INFORMADO'::character varying)::text])))
);

CREATE TABLE persona.persona_juridica (
    id bigint NOT NULL,
	version integer NOT NULL,
	id_persona bigint NOT NULL,
	cuit character varying(11) NOT NULL,
    denominacion character varying(255) NOT NULL,
	CONSTRAINT persona_juridica_pk PRIMARY KEY (id),
	CONSTRAINT persona_juridica_ipk UNIQUE (id_persona),
	CONSTRAINT persona_juridica_persona_fk FOREIGN KEY (id_persona) REFERENCES persona.persona (id),
	CONSTRAINT persona_juridica_cuit_ipk UNIQUE (cuit)
);

CREATE TABLE persona.cliente (
    id bigint NOT NULL,
	version integer NOT NULL,
	id_persona bigint NOT NULL,
	codigo integer NOT NULL,
    fecha_alta timestamp(6) without time zone NOT NULL,
	CONSTRAINT cliente_pk PRIMARY KEY (id),
	CONSTRAINT cliente_persona_ipk UNIQUE (id_persona),
	CONSTRAINT cliente_codigo_ipk UNIQUE (codigo),
	CONSTRAINT cliente_persona_fk FOREIGN KEY (id_persona) REFERENCES persona.persona (id)
);

CREATE TABLE persona.empleado (
    id bigint NOT NULL,
	version integer NOT NULL,
	id_persona_fisica bigint NOT NULL,
	codigo integer NOT NULL,
    fecha_alta timestamp(6) without time zone NOT NULL,
	id_sucursal bigint NOT NULL,
	CONSTRAINT empleado_pk PRIMARY KEY (id),
	CONSTRAINT empleado_persona_ipk UNIQUE (id_persona_fisica),
	CONSTRAINT empleado_codigo_ipk UNIQUE (codigo),
	CONSTRAINT empleado_persona_fk FOREIGN KEY (id_persona_fisica) REFERENCES persona.persona_fisica (id),
	CONSTRAINT empleado_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES persona.sucursal (id)
);

CREATE TABLE persona.proveedor (
    id bigint NOT NULL,
	version integer NOT NULL,
	id_persona_juridica bigint NOT NULL,
	codigo integer NOT NULL,
    fecha_alta timestamp(6) without time zone NOT NULL,
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
	version integer NOT NULL,
	codigo integer NOT NULL,
    descripcion character varying(50) NOT NULL,
	CONSTRAINT categoria_pk PRIMARY KEY (id),
	CONSTRAINT categoria_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE producto.subcategoria (
	id bigint NOT NULL,
	version integer NOT NULL,
	id_categoria bigint NOT NULL,
	codigo integer NOT NULL,
    descripcion character varying(50) NOT NULL,
	CONSTRAINT subcategoria_pk PRIMARY KEY (id),
	CONSTRAINT subcategoria_codigo_ipk UNIQUE (id_categoria, codigo),
	CONSTRAINT subcategoria_categoria_fk FOREIGN KEY (id_categoria) REFERENCES producto.categoria (id)
);

CREATE TABLE producto.marca (
    id bigint NOT NULL,
	version integer NOT NULL,
	codigo integer NOT NULL,
    descripcion character varying(50) NOT NULL,
	CONSTRAINT marca_pk PRIMARY KEY (id),
	CONSTRAINT marca_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE producto.producto (
	id bigint NOT NULL,
	version integer NOT NULL,
	codigo integer NOT NULL,
    descripcion character varying(50) NOT NULL,
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
	version integer NOT NULL,
	codigo integer NOT NULL,
    descripcion character varying(50) NOT NULL,
	porcentaje_descuento numeric,
	CONSTRAINT promocion_pk PRIMARY KEY (id),
	CONSTRAINT promocion_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE venta.forma_pago (
    id bigint NOT NULL,
	version integer NOT NULL,
	codigo integer NOT NULL,
    descripcion character varying(50) NOT NULL,
	porcentaje_descuento numeric NOT NULL,
	CONSTRAINT forma_pago_pk PRIMARY KEY (id),
	CONSTRAINT forma_pago_codigo_ipk UNIQUE (codigo)
);

CREATE TABLE venta.factura (
	id bigint NOT NULL,
	version integer NOT NULL,
	numero integer NOT NULL,
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
	version integer NOT NULL,
	id_factura bigint NOT NULL,
	item integer NOT NULL,
    id_producto bigint NOT NULL,
    cantidad numeric(38,2) NOT NULL,
    precio_unitario numeric(38,2) NOT NULL,
	CONSTRAINT factura_detalle_pk PRIMARY KEY (id),
	CONSTRAINT factura_item_ipk UNIQUE (id_factura, item),
	CONSTRAINT factura_detalle_factura_fk FOREIGN KEY (id_factura) REFERENCES venta.factura (id),
	CONSTRAINT factura_detalle_producto_fk FOREIGN KEY (id_producto) REFERENCES producto.producto (id)
);

-- select count(*) from venta.factura_detalle fd 

-- select * from venta.factura_detalle fd 
