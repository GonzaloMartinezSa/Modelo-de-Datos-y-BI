USE GD2C2022;

IF OBJECT_ID('PROBASTE_REINICIANDO') IS NOT NULL
BEGIN
	DROP PROCEDURE PROBASTE_REINICIANDO.creacionTablas;
	DROP PROCEDURE PROBASTE_REINICIANDO.cargar_datos;
	DROP SCHEMA PROBASTE_REINICIANDO;
END

GO
CREATE SCHEMA PROBASTE_REINICIANDO;
GO

CREATE TABLE PROBASTE_REINICIANDO.Medio_Pago_Compra(
	medio_compra_id INT NOT NULL IDENTITY(1,1),
	medio_compra_tipo nvarchar(255) UNIQUE,
	PRIMARY KEY(medio_compra_id)
);

CREATE TABLE PROBASTE_REINICIANDO.Tipo_Descuento(
	td_id INT NOT NULL IDENTITY(1,1),
	td_desc nvarchar(50) UNIQUE,
	PRIMARY KEY(td_id)
);

CREATE TABLE PROBASTE_REINICIANDO.Categoria_Producto(
	catp_id INT NOT NULL IDENTITY(1,1),
	catp_desc nvarchar(50) UNIQUE,
	PRIMARY KEY(catp_id)
);

CREATE TABLE PROBASTE_REINICIANDO.Compra(
	compra_codigo DECIMAL(19,0) NOT NULL,
	compra_fecha date NOT NULL,
	compra_total decimal(18,2) NOT NULL,
	compra_medio_pago INT,
	compra_provee nvarchar(50),
	PRIMARY KEY(compra_codigo)
);

CREATE TABLE PROBASTE_REINICIANDO.Proveedor(
	prov_cuit nvarchar(50) NOT NULL,
	prov_razon nvarchar(50) NOT NULL,
	prov_domicilio nvarchar(50),
	prov_mail nvarchar(50),
	prov_localidad INT,
	prov_provincia INT,
	prov_cod_postal nvarchar(50),
	PRIMARY KEY(prov_cuit)
);

CREATE TABLE PROBASTE_REINICIANDO.Item_Compra(
	item_compra DECIMAL(19,0) NOT NULL,
	item_c_vproducto nvarchar(50) NOT NULL,
	item_c_cantidad decimal(18,0),
	item_c_precio decimal(18,2),
	PRIMARY KEY(item_compra, item_c_vproducto)
);

CREATE TABLE PROBASTE_REINICIANDO.Producto(
	prod_codigo nvarchar(50),
	prod_nombre nvarchar(50),
	prod_desc nvarchar(50),
	prod_material nvarchar(50),
	prod_marca nvarchar(255),
	prod_categoria INT,
	PRIMARY KEY(prod_codigo)
);

CREATE TABLE PROBASTE_REINICIANDO.Variante_Producto(
	variante_codigo nvarchar(50),
	variante_prod nvarchar(50),
	variante_stock decimal(19,0),
	variante_descripcion nvarchar(255),
	variante_tipo INT,
	PRIMARY KEY(variante_codigo)
);

CREATE TABLE PROBASTE_REINICIANDO.Medio_Pago_Venta (
	medio_venta_id INT NOT NULL IDENTITY(1,1),
	medio_venta_tipo nvarchar(255),
	medio_venta_costo decimal(18,2),
	PRIMARY KEY(medio_venta_id)
);

CREATE TABLE PROBASTE_REINICIANDO.Canal_Venta (
	canal_id INT NOT NULL IDENTITY(1,1),
	canal_tipo nvarchar(255),
	canal_costo decimal(18,2),
	PRIMARY KEY(canal_id)
);

CREATE TABLE PROBASTE_REINICIANDO.Tipo_Envio (
	tipoenvio_id INT NOT NULL IDENTITY(1,1),
	tipoenvio_desc nvarchar(50) UNIQUE,
	PRIMARY KEY(tipoenvio_id)
);

CREATE TABLE PROBASTE_REINICIANDO.Envio (
	envio_localidad INT,
	envio_cp nvarchar(50),
	envio_tipo INT,
	envio_costo decimal(18,2),
	envio_t_estimado decimal(18,2)
	PRIMARY KEY (envio_localidad, envio_cp, envio_tipo)
);

CREATE TABLE PROBASTE_REINICIANDO.Codigo_Postal (
	cp nvarchar(50) NOT NULL,
	PRIMARY KEY(cp),
);

CREATE TABLE PROBASTE_REINICIANDO.Descuento_Compra (
	desc_c_codigo decimal(19,0) NOT NULL,
	desc_c_valor decimal(18,2),
	desc_c_compra decimal(19,0),
	PRIMARY KEY(desc_c_codigo)
);

CREATE TABLE PROBASTE_REINICIANDO.Descuento_Venta (
	desc_v_id INT NOT NULL IDENTITY(1,1),
	desc_v_valor decimal(18,2),
	desc_v_venta decimal(19,0),
	desc_v_tipo INT,
	PRIMARY KEY(desc_v_id)
);

CREATE TABLE PROBASTE_REINICIANDO.Cliente (
	cliente_id INT NOT NULL IDENTITY(1,1),
	cliente_nombre nvarchar(255),
	cliente_apellido nvarchar(255),
	dni  decimal(18,0),
	cliente_direccion nvarchar(255),
	cliente_telefono decimal(18,0),
	cliente_mail nvarchar(255),
	cod_postal nvarchar(50),
	cliente_fecha_nac date,
	cliente_localidad INT,
	cliente_provincia INT,
	PRIMARY KEY(cliente_id),
);

CREATE TABLE PROBASTE_REINICIANDO.Cupon (
	cupon_codigo nvarchar(255),
	cupon_desde date,
	cupon_hasta date,
	cupon_tipo nvarchar(255),
	cupon_valor decimal(18,2),
	PRIMARY KEY(cupon_codigo),
);

CREATE TABLE PROBASTE_REINICIANDO.Localidad(
	loc_id INT NOT NULL IDENTITY(1,1),
	loc_nombre nvarchar(255) UNIQUE,
	PRIMARY KEY(loc_id)
);

CREATE TABLE PROBASTE_REINICIANDO.Provincia (
	provi_id INT NOT NULL IDENTITY(1,1),
	provi_nombre nvarchar(50) UNIQUE,
	PRIMARY KEY(provi_id),
);

CREATE TABLE PROBASTE_REINICIANDO.Tipo_Variante (
	tvariante_id INT NOT NULL IDENTITY(1,1),
	descripcion nvarchar(50) UNIQUE,
	PRIMARY KEY(tvariante_id),
);

CREATE TABLE PROBASTE_REINICIANDO.Cupon_Venta (
	cv_cupon nvarchar(255) NOT NULL,
	cv_venta decimal(19,0) NOT NULL,
	cupon_importe decimal(18,2),
	PRIMARY KEY(cv_cupon,cv_venta),
);

CREATE TABLE PROBASTE_REINICIANDO.Item_Venta (
	item_venta decimal(19,0) NOT NULL,
	item_v_vproducto nvarchar(50) NOT NULL,
	item_v_cantidad decimal(18,0),
	item_v_precio decimal(18,2),
	PRIMARY KEY(item_venta, item_v_vproducto),
);

CREATE TABLE PROBASTE_REINICIANDO.Venta (
	venta_codigo decimal(19,0) NOT NULL,
	venta_fecha date,
	venta_total decimal(18,2),
	venta_medio_pago INT,
	venta_envio INT,
	venta_canal INT,
	venta_cliente INT,
	venta_envio_gratis smallint,
	venta_costo_canal decimal(18,2),
	venta_costo_mediopago decimal(18,2),
	venta_costo_envio decimal(18,2)
	primary key (venta_codigo)
);

ALTER TABLE PROBASTE_REINICIANDO.Compra ADD FOREIGN KEY (compra_medio_pago) REFERENCES PROBASTE_REINICIANDO.Medio_Pago_Compra(medio_compra_id);
ALTER TABLE PROBASTE_REINICIANDO.Compra ADD FOREIGN KEY (compra_provee) REFERENCES PROBASTE_REINICIANDO.Proveedor(prov_cuit);

ALTER TABLE PROBASTE_REINICIANDO.Proveedor ADD FOREIGN KEY (prov_provincia) REFERENCES PROBASTE_REINICIANDO.Provincia(provi_id);
ALTER TABLE PROBASTE_REINICIANDO.Proveedor ADD FOREIGN KEY (prov_cod_postal) REFERENCES PROBASTE_REINICIANDO.Codigo_Postal(cp);
ALTER TABLE PROBASTE_REINICIANDO.Proveedor ADD FOREIGN KEY (prov_localidad) REFERENCES PROBASTE_REINICIANDO.Localidad(loc_id);

ALTER TABLE PROBASTE_REINICIANDO.Item_Compra ADD FOREIGN KEY (item_compra) REFERENCES PROBASTE_REINICIANDO.Compra(compra_codigo);
ALTER TABLE PROBASTE_REINICIANDO.Item_Compra ADD FOREIGN KEY (item_c_vproducto) REFERENCES PROBASTE_REINICIANDO.Variante_Producto(variante_codigo);

ALTER TABLE PROBASTE_REINICIANDO.Item_Venta ADD FOREIGN KEY (item_venta) REFERENCES PROBASTE_REINICIANDO.Venta(venta_codigo);
ALTER TABLE PROBASTE_REINICIANDO.Item_Venta ADD FOREIGN KEY (item_v_vproducto) REFERENCES PROBASTE_REINICIANDO.Variante_Producto(variante_codigo);

ALTER TABLE PROBASTE_REINICIANDO.Producto ADD FOREIGN KEY (prod_categoria) REFERENCES PROBASTE_REINICIANDO.Categoria_Producto(catp_id);

ALTER TABLE PROBASTE_REINICIANDO.Variante_Producto ADD FOREIGN KEY (variante_tipo) REFERENCES PROBASTE_REINICIANDO.Tipo_Variante(tvariante_id);
ALTER TABLE PROBASTE_REINICIANDO.Variante_Producto ADD FOREIGN KEY (variante_prod) REFERENCES PROBASTE_REINICIANDO.Producto(prod_codigo);

ALTER TABLE PROBASTE_REINICIANDO.Cliente ADD FOREIGN KEY (cod_postal) REFERENCES  PROBASTE_REINICIANDO.Codigo_Postal(cp);
ALTER TABLE PROBASTE_REINICIANDO.Cliente ADD FOREIGN KEY (cliente_provincia) REFERENCES  PROBASTE_REINICIANDO.Provincia(provi_id);
ALTER TABLE PROBASTE_REINICIANDO.Cliente ADD FOREIGN KEY (cliente_localidad) REFERENCES PROBASTE_REINICIANDO.Localidad(loc_id);

ALTER TABLE PROBASTE_REINICIANDO.Descuento_Compra ADD FOREIGN KEY (desc_c_compra) REFERENCES PROBASTE_REINICIANDO.Compra(compra_codigo);
ALTER TABLE PROBASTE_REINICIANDO.Descuento_Venta ADD FOREIGN KEY (desc_v_venta) REFERENCES PROBASTE_REINICIANDO.Venta(venta_codigo);
ALTER TABLE PROBASTE_REINICIANDO.Descuento_Venta ADD FOREIGN KEY (desc_v_tipo) REFERENCES PROBASTE_REINICIANDO.Tipo_Descuento(td_id);

ALTER TABLE PROBASTE_REINICIANDO.Envio ADD FOREIGN KEY (envio_localidad) REFERENCES PROBASTE_REINICIANDO.Localidad(loc_id);
ALTER TABLE PROBASTE_REINICIANDO.Envio ADD FOREIGN KEY (envio_cp) REFERENCES PROBASTE_REINICIANDO.Codigo_Postal(cp);
ALTER TABLE PROBASTE_REINICIANDO.Envio ADD FOREIGN KEY (envio_tipo) REFERENCES PROBASTE_REINICIANDO.Tipo_Envio(tipoenvio_id);
--ALTER TABLE Envio ADD CONSTRAINT def_envio_monto DEFAULT 0 for envio_monto_trigger;

ALTER TABLE PROBASTE_REINICIANDO.Venta ADD FOREIGN KEY (venta_medio_pago) REFERENCES PROBASTE_REINICIANDO.Medio_Pago_Venta(medio_venta_id);
ALTER TABLE PROBASTE_REINICIANDO.Venta ADD FOREIGN KEY (venta_envio) REFERENCES PROBASTE_REINICIANDO.Tipo_Envio(tipoenvio_id);
ALTER TABLE PROBASTE_REINICIANDO.Venta ADD FOREIGN KEY (venta_canal) REFERENCES PROBASTE_REINICIANDO.Canal_Venta(canal_id);
ALTER TABLE PROBASTE_REINICIANDO.Venta ADD FOREIGN KEY (venta_cliente) REFERENCES PROBASTE_REINICIANDO.Cliente(cliente_id);

ALTER TABLE PROBASTE_REINICIANDO.Cupon_Venta ADD FOREIGN KEY (cv_cupon) REFERENCES PROBASTE_REINICIANDO.Cupon(cupon_codigo);
ALTER TABLE PROBASTE_REINICIANDO.Cupon_Venta ADD FOREIGN KEY (cv_venta) REFERENCES PROBASTE_REINICIANDO.Venta(venta_codigo);

ALTER TABLE PROBASTE_REINICIANDO.Tipo_Variante ADD CONSTRAINT uni_variante UNIQUE(descripcion);
ALTER TABLE PROBASTE_REINICIANDO.Tipo_Envio ADD CONSTRAINT uni_tenvio UNIQUE(tipoenvio_desc);
ALTER TABLE PROBASTE_REINICIANDO.Canal_Venta ADD CONSTRAINT uni_cventa UNIQUE(canal_tipo,canal_costo);
ALTER TABLE PROBASTE_REINICIANDO.Producto ADD CONSTRAINT uni_prod UNIQUE(prod_nombre,prod_desc);
ALTER TABLE PROBASTE_REINICIANDO.Proveedor ADD CONSTRAINT uni_prove UNIQUE(prov_cuit,prov_razon);
ALTER TABLE PROBASTE_REINICIANDO.Categoria_Producto ADD CONSTRAINT uni_cat UNIQUE(catp_desc);
ALTER TABLE PROBASTE_REINICIANDO.Tipo_Descuento ADD CONSTRAINT uniq_tdesc UNIQUE(td_desc);
ALTER TABLE PROBASTE_REINICIANDO.Variante_Producto ADD CONSTRAINT stock_0 DEFAULT 0 for variante_stock;

ALTER TABLE PROBASTE_REINICIANDO.Venta ADD CONSTRAINT enviopago DEFAULT 0 for venta_envio_gratis;

--Medio de Pago Compra
INSERT INTO PROBASTE_REINICIANDO.Medio_Pago_Compra (medio_compra_tipo) 
(SELECT DISTINCT(COMPRA_MEDIO_PAGO) FROM gd_esquema.Maestra WHERE COMPRA_MEDIO_PAGO IS NOT NULL);

--Provincia
INSERT INTO PROBASTE_REINICIANDO.Provincia (provi_nombre)
(SELECT DISTINCT(CLIENTE_PROVINCIA) from gd_esquema.Maestra WHERE CLIENTE_PROVINCIA IS NOT NULL 
UNION 
SELECT DISTINCT(PROVEEDOR_PROVINCIA) from gd_esquema.Maestra WHERE PROVEEDOR_PROVINCIA IS NOT NULL);

--Codigo Postal
INSERT INTO PROBASTE_REINICIANDO.Codigo_Postal (cp)
(SELECT DISTINCT PROVEEDOR_CODIGO_POSTAL from gd_esquema.Maestra where PROVEEDOR_CODIGO_POSTAL IS NOT NULL
UNION
SELECT DISTINCT CLIENTE_CODIGO_POSTAL from gd_esquema.Maestra where CLIENTE_CODIGO_POSTAL IS NOT NULL);

--Localidad
INSERT INTO PROBASTE_REINICIANDO.Localidad (loc_nombre)
(select distinct CLIENTE_LOCALIDAD from gd_esquema.Maestra where CLIENTE_LOCALIDAD is not null
UNION
select distinct PROVEEDOR_LOCALIDAD from gd_esquema.Maestra where PROVEEDOR_LOCALIDAD is not null);

--Cupon
INSERT INTO PROBASTE_REINICIANDO.Cupon (cupon_codigo, cupon_tipo, cupon_desde, cupon_hasta, cupon_valor)
(select distinct VENTA_CUPON_CODIGO, VENTA_CUPON_TIPO, VENTA_CUPON_FECHA_DESDE,
	VENTA_CUPON_FECHA_HASTA, VENTA_CUPON_VALOR  from gd_esquema.Maestra where VENTA_CUPON_CODIGO IS NOT NULL);

--Producto Categoria
INSERT INTO PROBASTE_REINICIANDO.Categoria_Producto (catp_desc)
(select distinct PRODUCTO_CATEGORIA from gd_esquema.Maestra
where PRODUCTO_CATEGORIA is not null);

--Tipo Variante
INSERT INTO PROBASTE_REINICIANDO.Tipo_Variante (descripcion)
(select distinct PRODUCTO_TIPO_VARIANTE from gd_esquema.Maestra
where PRODUCTO_TIPO_VARIANTE is not null);

--Canal Venta
INSERT INTO PROBASTE_REINICIANDO.Canal_Venta (canal_tipo, canal_costo)
(select DISTINCT VENTA_CANAL, VENTA_CANAL_COSTO from gd_esquema.Maestra
where VENTA_CANAL is not null and VENTA_FECHA = 
(SELECT MAX(vc1.VENTA_FECHA) from gd_esquema.Maestra vc1 where vc1.VENTA_CANAL = VENTA_CANAL)
);

--Tipo Envio
INSERT INTO PROBASTE_REINICIANDO.Tipo_Envio (tipoenvio_desc)
(select distinct VENTA_MEDIO_ENVIO from gd_esquema.Maestra
where VENTA_MEDIO_ENVIO is not null);

--Proveedor
INSERT INTO PROBASTE_REINICIANDO.Proveedor (prov_cuit, prov_razon, prov_domicilio, prov_mail, prov_localidad, prov_cod_postal, prov_provincia)
(select distinct PROVEEDOR_CUIT, PROVEEDOR_RAZON_SOCIAL, PROVEEDOR_DOMICILIO, PROVEEDOR_MAIL, 
(select loc_id from PROBASTE_REINICIANDO.Localidad where loc_nombre = PROVEEDOR_LOCALIDAD), 
PROVEEDOR_CODIGO_POSTAL,
(select provi_id from PROBASTE_REINICIANDO.Provincia where PROVEEDOR_PROVINCIA=provi_nombre)
from gd_esquema.Maestra
where PROVEEDOR_CUIT is not null);

--Producto
INSERT INTO PROBASTE_REINICIANDO.Producto (prod_codigo, prod_nombre, prod_desc, prod_material, prod_marca, prod_categoria)
select distinct PRODUCTO_CODIGO, PRODUCTO_NOMBRE, PRODUCTO_DESCRIPCION, PRODUCTO_MATERIAL, PRODUCTO_MARCA,
(select catp_id from PROBASTE_REINICIANDO.Categoria_Producto where PRODUCTO_CATEGORIA = catp_desc)
from gd_esquema.Maestra where PRODUCTO_CODIGO IS NOT NULL;

--Variante
INSERT INTO PROBASTE_REINICIANDO.Variante_Producto (variante_prod, variante_codigo, variante_descripcion, variante_tipo, variante_stock)
(select distinct PRODUCTO_CODIGO, PRODUCTO_VARIANTE_CODIGO, PRODUCTO_VARIANTE, 
(select tvariante_id from PROBASTE_REINICIANDO.Tipo_Variante where descripcion = PRODUCTO_TIPO_VARIANTE),
(select SUM(ISNULL(COMPRA_PRODUCTO_CANTIDAD,0)) - SUM(ISNULL(VENTA_PRODUCTO_CANTIDAD,0)) from gd_esquema.Maestra WHERE (COMPRA_PRODUCTO_CANTIDAD IS NOT NULL or VENTA_PRODUCTO_CANTIDAD IS NOT NULL) AND PRODUCTO_VARIANTE_CODIGO =  t1.PRODUCTO_VARIANTE_CODIGO GROUP BY PRODUCTO_VARIANTE_CODIGO)
from gd_esquema.Maestra t1 where PRODUCTO_VARIANTE_CODIGO IS NOT NULL);

--Compra
INSERT INTO PROBASTE_REINICIANDO.Compra (compra_codigo, compra_fecha, compra_total, compra_medio_pago, compra_provee)
(select distinct COMPRA_NUMERO, COMPRA_FECHA, COMPRA_TOTAL,
(select medio_compra_id from PROBASTE_REINICIANDO.Medio_Pago_Compra where COMPRA_MEDIO_PAGO = medio_compra_tipo),
(select prov_cuit from PROBASTE_REINICIANDO.Proveedor where PROVEEDOR_CUIT = prov_cuit)
from gd_esquema.Maestra where COMPRA_MEDIO_PAGO IS NOT NULL);

--Cliente
INSERT INTO PROBASTE_REINICIANDO.Cliente (cliente_nombre, cliente_apellido, dni, cliente_direccion, cliente_telefono, cliente_mail, cod_postal, cliente_fecha_nac, cliente_localidad,cliente_provincia)
(SELECT DISTINCT CLIENTE_NOMBRE,CLIENTE_APELLIDO,CLIENTE_DNI,CLIENTE_DIRECCION,CLIENTE_TELEFONO,CLIENTE_MAIL, CLIENTE_CODIGO_POSTAL, CLIENTE_FECHA_NAC,
(select loc_id from PROBASTE_REINICIANDO.Localidad where loc_nombre = CLIENTE_LOCALIDAD), 
(SELECT provi_id from PROBASTE_REINICIANDO.Provincia where provi_nombre = CLIENTE_PROVINCIA)
FROM gd_esquema.Maestra WHERE CLIENTE_DNI IS NOT NULL);

--Item_compra
INSERT INTO PROBASTE_REINICIANDO.Item_Compra (item_compra, item_c_vproducto, item_c_cantidad,item_c_precio)
SELECT DISTINCT COMPRA_NUMERO, PRODUCTO_VARIANTE_CODIGO, SUM(COMPRA_PRODUCTO_CANTIDAD), COMPRA_PRODUCTO_PRECIO FROM gd_esquema.Maestra WHERE COMPRA_NUMERO IS NOT NULL AND PRODUCTO_VARIANTE_CODIGO IS NOT NULL AND COMPRA_PRODUCTO_CANTIDAD IS NOT NULL
GROUP BY COMPRA_NUMERO, PRODUCTO_VARIANTE_CODIGO, COMPRA_PRODUCTO_PRECIO;

--Medio de Pago Venta
INSERT INTO PROBASTE_REINICIANDO.Medio_Pago_Venta (medio_venta_tipo, medio_venta_costo)
select distinct venta_medio_pago, VENTA_MEDIO_PAGO_COSTO from gd_esquema.Maestra 
where VENTA_MEDIO_PAGO is not null and VENTA_FECHA = (SELECT MAX(gd1.VENTA_FECHA) from gd_esquema.Maestra gd1 where gd1.VENTA_MEDIO_PAGO = VENTA_MEDIO_PAGO);

--Envio
INSERT INTO PROBASTE_REINICIANDO.Envio(envio_cp, envio_localidad, envio_tipo, envio_costo)
(select distinct CLIENTE_CODIGO_POSTAL, 
(select loc_id from PROBASTE_REINICIANDO.Localidad where loc_nombre = CLIENTE_LOCALIDAD), 
(select tipoenvio_id from PROBASTE_REINICIANDO.Tipo_Envio where tipoenvio_desc = VENTA_MEDIO_ENVIO), 
VENTA_ENVIO_PRECIO
from gd_esquema.Maestra
where CLIENTE_CODIGO_POSTAL is not null and VENTA_FECHA = (SELECT MAX(vc1.VENTA_FECHA) from gd_esquema.Maestra vc1 where vc1.VENTA_FECHA = VENTA_FECHA));

--Venta
INSERT INTO PROBASTE_REINICIANDO.Venta (venta_codigo, venta_fecha, venta_envio_gratis, venta_total, venta_medio_pago, venta_envio, venta_canal, venta_cliente, venta_costo_canal, venta_costo_mediopago, venta_costo_envio)
SELECT VENTA_CODIGO, VENTA_FECHA, CASE SUM(VENTA_ENVIO_PRECIO) WHEN 0 THEN 1 ELSE 0 END, SUM(VENTA_TOTAL),
(SELECT medio_venta_id from PROBASTE_REINICIANDO.Medio_Pago_Venta where VENTA_MEDIO_PAGO = medio_venta_tipo),
(SELECT tipoenvio_id from PROBASTE_REINICIANDO.Tipo_Envio where VENTA_MEDIO_ENVIO=tipoenvio_desc),
(SELECT canal_id from PROBASTE_REINICIANDO.Canal_venta where canal_tipo = VENTA_CANAL),
(SELECT cliente_id from PROBASTE_REINICIANDO.Cliente where cliente_nombre = CLIENTE_NOMBRE AND cliente_apellido = CLIENTE_APELLIDO AND dni = CLIENTE_DNI AND cliente_direccion = CLIENTE_DIRECCION AND cliente_telefono = CLIENTE_TELEFONO AND cliente_mail = CLIENTE_MAIL AND cod_postal = CLIENTE_CODIGO_POSTAL AND cliente_fecha_nac = CLIENTE_FECHA_NAC AND cliente_localidad = CLIENTE_LOCALIDAD),
VENTA_CANAL_COSTO, VENTA_MEDIO_PAGO_COSTO, VENTA_ENVIO_PRECIO
from gd_esquema.Maestra
WHERE VENTA_CODIGO IS NOT NULL AND VENTA_FECHA IS NOT NULL AND VENTA_TOTAL IS NOT NULL
GROUP BY VENTA_CODIGO, VENTA_FECHA,VENTA_ENVIO_PRECIO, VENTA_MEDIO_PAGO,VENTA_MEDIO_ENVIO,VENTA_CANAL,CLIENTE_NOMBRE,CLIENTE_APELLIDO,CLIENTE_DNI,CLIENTE_DIRECCION,CLIENTE_TELEFONO,CLIENTE_MAIL,CLIENTE_CODIGO_POSTAL,CLIENTE_FECHA_NAC,CLIENTE_LOCALIDAD,VENTA_CANAL_COSTO, VENTA_MEDIO_PAGO_COSTO, VENTA_ENVIO_PRECIO;

--Item_Venta
INSERT INTO PROBASTE_REINICIANDO.Item_Venta (item_venta, item_v_vproducto, item_v_precio, item_v_cantidad)
(select distinct VENTA_CODIGO, PRODUCTO_VARIANTE_CODIGO, VENTA_PRODUCTO_PRECIO, sum(VENTA_PRODUCTO_CANTIDAD)
from gd_esquema.Maestra
where VENTA_CODIGO is not null and PRODUCTO_VARIANTE_CODIGO is not null
group by VENTA_CODIGO, PRODUCTO_VARIANTE_CODIGO, VENTA_PRODUCTO_PRECIO)

--Tipo Descuento
INSERT INTO PROBASTE_REINICIANDO.Tipo_Descuento (td_desc)
(select distinct VENTA_DESCUENTO_CONCEPTO
from gd_esquema.Maestra
where VENTA_DESCUENTO_CONCEPTO is not null)

-- Descuento ventas
INSERT INTO PROBASTE_REINICIANDO.Descuento_Venta(desc_v_valor,desc_v_venta, desc_v_tipo)
SELECT SUM(VENTA_DESCUENTO_IMPORTE), VENTA_CODIGO, 
(SELECT td_id from PROBASTE_REINICIANDO.Tipo_Descuento where td_desc = VENTA_DESCUENTO_CONCEPTO)
from gd_esquema.Maestra 
WHERE VENTA_CODIGO IS NOT NULL AND VENTA_DESCUENTO_IMPORTE IS NOT NULL AND VENTA_DESCUENTO_CONCEPTO IS NOT NULL
GROUP BY VENTA_CODIGO, VENTA_DESCUENTO_CONCEPTO;

-- Descuento compras
INSERT INTO PROBASTE_REINICIANDO.Descuento_Compra(desc_c_codigo, desc_c_valor, desc_c_compra)
SELECT DESCUENTO_COMPRA_CODIGO, SUM(DESCUENTO_COMPRA_VALOR), COMPRA_NUMERO
FROM gd_esquema.Maestra
WHERE COMPRA_NUMERO IS NOT NULL AND DESCUENTO_COMPRA_CODIGO IS NOT NULL AND DESCUENTO_COMPRA_VALOR IS NOT NULL
GROUP BY DESCUENTO_COMPRA_CODIGO, COMPRA_NUMERO;

-- Cupon Venta
INSERT INTO PROBASTE_REINICIANDO.Cupon_Venta(cv_venta, cv_cupon, cupon_importe)
(select distinct VENTA_CODIGO, VENTA_CUPON_CODIGO, VENTA_CUPON_IMPORTE
from gd_esquema.Maestra
where VENTA_CUPON_CODIGO is not null and VENTA_CODIGO is not null);

--TRIGGERS
GO
CREATE TRIGGER PROBASTE_REINICIANDO.trg_stock_compra ON PROBASTE_REINICIANDO.Item_Compra AFTER INSERT AS
BEGIN
DECLARE @vproducto nvarchar(50);
SET @vproducto = (SELECT item_c_vproducto FROM INSERTED);
UPDATE Variante_Producto
SET variante_stock = (SELECT variante_stock from Variante_Producto WHERE variante_codigo = @vproducto) + (SELECT item_c_cantidad FROM INSERTED)
WHERE variante_codigo = @vproducto;
END
GO

GO
CREATE TRIGGER PROBASTE_REINICIANDO.trg_stock_venta ON PROBASTE_REINICIANDO.item_venta AFTER INSERT AS
BEGIN
DECLARE @vproducto1 nvarchar(50);
SET @vproducto1 = (SELECT item_v_vproducto FROM INSERTED);
UPDATE Variante_Producto
SET variante_stock = (SELECT variante_stock from Variante_Producto WHERE variante_codigo = @vproducto1) - (SELECT item_v_cantidad FROM INSERTED)
WHERE variante_codigo = @vproducto1;
END
GO

