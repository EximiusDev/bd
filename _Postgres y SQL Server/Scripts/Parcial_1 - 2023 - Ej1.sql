
/*
 ============================================
 Ejercicio_1
 ============================================
 */

-- no esta subido a la base de datos
-- REVISAR LA CREACION DE INDICES

/* USE 
*/

/*
CREATE TABLE Tematica(
idtema		int2			NOT NULL, -- idtema		SERIAL
nomtema		char(40)		NOT NULL,
CONSTRAINT pk_tematica primary key (idtema)
);
*/

CREATE TABLE Localidad(
idloca		int2			NOT NULL, -- idtema		SERIAL
nomloca		char(40)		NOT NULL,
CONSTRAINT pk_localidad primary key (idloca)
);

CREATE TABLE Persona(
tipodocu	char(1)			NOT NULL, -- idtema		SERIAL
nrodocu		int4			NOT NULL,
idloca		int2			NOT NULL,
apenom		char(40)		NOT NULL,
domiper		char(40)		NOT NULL,
CONSTRAINT pk_persona primary key (tipodocu, nrodocu),
constraint fk_persona_localidad foreign key (idloca) references Localidad (idloca),

CONSTRAINT persona_chk CHECK (tipodocu IN('1','2','3','4','5','6'))

);

CREATE INDEX idx_persona_localidad ON Persona( idloca); -- indice

CREATE TABLE Empleado(
idemple		int2			NOT NULL,
tipodocu	char(40)		NOT NULL, -- idtema		SERIAL
nrodocu		int4			NOT NULL,
feingre		date			NOT NULL,
CONSTRAINT pk_empleado primary key (idemple),
constraint fk_empleado_persona foreign key (tipodocu, nrodocu) references persona ( tipodocu, nrodocu)
);

CREATE INDEX idx_empleado_persona ON Empleado( tipodocu, nrodocu); -- indice

CREATE TABLE Nivel(
idnivel		int2			NOT NULL, -- idtema		SERIAL
nomnivel	char(20)		NOT NULL,
CONSTRAINT pk_nivel primary key (idnivel)
);

CREATE TABLE Oficina(
idofi		int2			NOT NULL,
idnivel		int2			NOT NULL,
idemple		int2			NOT NULL,
nomofi		char(40)		NOT NULL,
CONSTRAINT pk_oficina primary key (idofi),
constraint fk_oficina_nivel foreign key (idnivel) references nivel ( idnivel),
constraint fk_oficina_empleado foreign key ( idemple) references empleado (idemple)
);
/*
alter table Oficina add constraint pk_oficina primary key (idofi);
alter table Oficina add constraint fk_oficina_empleado foreign key (idemple) references nivel_1.seccion (idemple);

alter table nivel_2.sector add constraint pk_sector primary key (id_seccion, id);
alter table nivel_2.sector add constraint fk_sector_seccion foreign key (id_seccion) references nivel_1.seccion (id);
 */

CREATE INDEX idx_oficina_empleado ON Oficina( idemple); -- indice

CREATE TABLE Actuacion(
nroactua		int2		NOT NULL,
anioactua		int2		NOT NULL,
nroactua_fk		int2		NULL,
anioactua_fk	int2		NULL,
feactua			date		NOT NULL,
CONSTRAINT pk_atuacion primary key (nroactua, anioactua),
constraint fk_atuacion_atuacion foreign key (nroactua , anioactua) references Actuacion ( nroactua , anioactua)
);

--CREATE INDEX idx_actuacion_actuacion ON actuacion(nroactua_fk,anioactua_fk); -- indice

CREATE TABLE Movimiento(
nromov		int2			NOT NULL,
nroactua	int2			NOT NULL,
anioactua	int2			NOT NULL,
idofi		int2			NOT NULL,
idnivel		int2			NOT NULL,
feingreso	date			NOT NULL,
prioridad	char(2)			NOT NULL,
observ		varchar(255)	NULL,
fesalida	date			NULL,
CONSTRAINT pk_movimiento primary key (nroactua, anioactua, nromov),
constraint fk_movimiento_oficina foreign key (idofi, idnivel) references oficina ( idofi, idnivel),
constraint fk_movimiento_actuacion foreign key ( nroactua, anioactua) references Actuacion (nroactua, anioactua),

CONSTRAINT movimiento_chk CHECK ( prioridad IN('AL','ME','BA') )
);


CREATE INDEX idx_movimiento_oficina ON Movimiento( idofi, idnivel); -- indice
CREATE INDEX idx_movimiento_actuacion ON Movimiento( nroactua, anioactua); -- indice
