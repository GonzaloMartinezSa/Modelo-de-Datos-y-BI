USE GD2C2022;

CREATE TABLE PROBASTE_REINICIANDO.BI_Dimension_Proveedor(
	prov_cuit nvarchar(50),
	prov_razonsocial nvarchar(50) UNIQUE NOT NULL,
	PRIMARY KEY(prov_cuit)
);

CREATE TABLE PROBASTE_REINICIANDO.BI_Dimension_Producto(
	prod_id nvarchar(50),
	prod_nombre nvarchar(50) UNIQUE  NOT NULL,
	PRIMARY KEY(prod_id)
);

create table PROBASTE_REINICIANDO.BI_Dimension_Tiempo (
    t_id int NOT NULL IDENTITY(1,1),
    t_ano int  NOT NULL,
    t_mes int  NOT NULL,
    primary key (t_id)
);

CREATE TABLE PROBASTE_REINICIANDO.BI_Dimension_RangoEtario(
	re_id INT IDENTITY(1,1),
	re_limiteinf INT  NOT NULL,
	re_limitesup INT  NOT NULL,
	PRIMARY KEY(re_id)
);

CREATE TABLE PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta(
	cv_id INT IDENTITY(1,1),
	cv_tipo nvarchar(255) UNIQUE  NOT NULL,
	PRIMARY KEY(cv_id)
);

CREATE TABLE PROBASTE_REINICIANDO.BI_Dimension_MedioPago(
	mp_id INT IDENTITY(1,1),
	mp_nombre nvarchar(255) UNIQUE  NOT NULL,
	PRIMARY KEY(mp_id)
);


CREATE TABLE PROBASTE_REINICIANDO.BI_Dimension_CategoriaProducto(
	cat_id INT IDENTITY(1,1),
	cat_desc nvarchar(50) UNIQUE  NOT NULL,
	PRIMARY KEY(cat_id)
);

create table PROBASTE_REINICIANDO.BI_Dimension_Provincia (
    provi_id int NOT NULL IDENTITY(1,1),
    provi_nombre nvarchar(50) UNIQUE  NOT NULL,
    primary key (provi_id)
);

create table PROBASTE_REINICIANDO.BI_Dimension_Tipo_Descuento_Venta (
    td_id int NOT NULL IDENTITY(1,1),
    td_desc nvarchar(50) UNIQUE  NOT NULL,
    primary key (td_id)
);

create table PROBASTE_REINICIANDO.BI_Dimension_Tipo_Envio (
    te_id int NOT NULL IDENTITY(1,1),
    te_desc nvarchar(50) UNIQUE NOT NULL,
    primary key (te_id)
);

create table PROBASTE_REINICIANDO.BI_Dimension_Compra (
    d_compra_id int NOT NULL IDENTITY(1,1),
    d_compra_total decimal(18,2),
    primary key (d_compra_id)
);

-- Compra
insert into PROBASTE_REINICIANDO.BI_Dimension_Compra(d_compra_total)
select compra_total from PROBASTE_REINICIANDO.Compra

-- Tiempo
insert into PROBASTE_REINICIANDO.BI_Dimension_Tiempo (t_ano, t_mes)
(select DISTINCT year(venta_fecha), month(venta_fecha) from PROBASTE_REINICIANDO.Venta
UNION
select DISTINCT year(compra_fecha), month(compra_fecha) from PROBASTE_REINICIANDO.Compra);

-- Categoria producto
INSERT INTO PROBASTE_REINICIANDO.BI_Dimension_CategoriaProducto(cat_desc)
(SELECT DISTINCT catp_desc from PROBASTE_REINICIANDO.Categoria_Producto);

-- Producto
INSERT INTO PROBASTE_REINICIANDO.BI_Dimension_Producto(prod_id, prod_nombre)
(SELECT DISTINCT prod_codigo, prod_nombre from PROBASTE_REINICIANDO.Producto);

-- MedioPago
INSERT INTO PROBASTE_REINICIANDO.BI_Dimension_MedioPago(mp_nombre)
(SELECT DISTINCT medio_venta_tipo from PROBASTE_REINICIANDO.Medio_Pago_Venta);

-- Rango etarios
insert into PROBASTE_REINICIANDO.BI_Dimension_RangoEtario (re_limiteinf, re_limitesup)
values 
(0,25),
(25,35),
(35,55),
(55,1000);

-- Proveedor
INSERT INTO PROBASTE_REINICIANDO.BI_Dimension_Proveedor(prov_cuit, prov_razonsocial)
(SELECT DISTINCT prov_cuit, prov_razon from PROBASTE_REINICIANDO.Proveedor);

-- Tipo Descuento Venta
INSERT INTO PROBASTE_REINICIANDO.BI_Dimension_Tipo_Descuento_Venta(td_desc)
(SELECT DISTINCT td_desc from PROBASTE_REINICIANDO.Tipo_Descuento);

INSERT INTO PROBASTE_REINICIANDO.BI_Dimension_Tipo_Descuento_Venta(td_desc)
values ('cupon');

-- Canal venta
insert into PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta (cv_tipo)
select canal_tipo from PROBASTE_REINICIANDO.Canal_Venta;

-- Provincia
insert into PROBASTE_REINICIANDO.BI_Dimension_Provincia (provi_nombre)
(SELECT DISTINCT provi_nombre from PROBASTE_REINICIANDO.Provincia);

-- Tipo de Envio
insert into PROBASTE_REINICIANDO.BI_Dimension_Tipo_Envio (te_desc)
select tipoenvio_desc from PROBASTE_REINICIANDO.Tipo_Envio;

--HECHO VENTA 
create table PROBASTE_REINICIANDO.BI_Hecho_Venta(
    v_mp int not null,
    v_canal int not null,
    v_tiempo int not null,
    v_total_descuentos decimal(18,2),
    v_mp_costo int,
	v_total decimal(18,2)
    PRIMARY KEY(v_mp, v_canal, v_tiempo)
);

alter table PROBASTE_REINICIANDO.BI_Hecho_Venta add foreign key (v_mp) references PROBASTE_REINICIANDO.BI_Dimension_MedioPago(mp_id);
alter table PROBASTE_REINICIANDO.BI_Hecho_Venta add foreign key (v_canal) references PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta(cv_id);
alter table PROBASTE_REINICIANDO.BI_Hecho_Venta add foreign key (v_tiempo) references PROBASTE_REINICIANDO.BI_Dimension_Tiempo(t_id);


insert into PROBASTE_REINICIANDO.BI_Hecho_Venta(v_mp, v_canal, v_tiempo, v_mp_costo, v_total_descuentos, v_total)
SELECT dmp1.mp_id, cv_id, t1.t_id, SUM(mpv1.medio_venta_costo), ISNULL((SELECT SUM(desc_v_valor) from PROBASTE_REINICIANDO.Descuento_venta
JOIN PROBASTE_REINICIANDO.Venta v2 ON desc_v_venta = v2.venta_codigo
JOIN PROBASTE_REINICIANDO.Tipo_Descuento ON desc_v_tipo = td_id
JOIN PROBASTE_REINICIANDO.Medio_Pago_Venta mpv2 ON v2.venta_medio_pago = mpv2.medio_venta_id
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo t2 ON YEAR(v2.venta_fecha) = t2.t_ano and MONTH(v2.venta_fecha) = t2.t_mes
WHERE mpv2.medio_venta_id = mpv1.medio_venta_id and t1.t_id = t2.t_id
GROUP BY t2.t_id, mpv2.medio_venta_id
) ,0), SUM(venta_total) 
FROM PROBASTE_REINICIANDO.Venta v1
JOIN PROBASTE_REINICIANDO.Medio_Pago_Venta mpv1 ON v1.venta_medio_pago = mpv1.medio_venta_id
JOIN PROBASTE_REINICIANDO.BI_Dimension_MedioPago dmp1 ON mpv1.medio_venta_id = dmp1.mp_id
JOIN PROBASTE_REINICIANDO.Canal_venta ON canal_id = venta_canal
JOIN PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta ON canal_tipo = cv_tipo
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo t1 ON YEAR(v1.venta_fecha) = t1.t_ano and MONTH(v1.venta_fecha) = t1.t_mes
GROUP BY mpv1.medio_venta_id, dmp1.mp_id, cv_id, t1.t_id


-- HECHO ITEM VENDIDO
--drop table PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido
create table PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido (
	hv_tiempo int not null,
	hv_clie_rangoetario int not null,
	hv_cat_prod int not null,
	hv_canal_venta int not null,
	hv_prod nvarchar(50) not null,
	hv_total decimal(18,2),
	hv_cant decimal(18,0),
	hv_precio decimal(18,2),
	PRIMARY KEY(hv_tiempo, hv_clie_rangoetario, hv_cat_prod, hv_canal_venta, hv_prod)
);

alter table PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido add foreign key (hv_tiempo) references PROBASTE_REINICIANDO.BI_Dimension_Tiempo(t_id);
alter table PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido add foreign key (hv_clie_rangoetario) references PROBASTE_REINICIANDO.BI_Dimension_RangoEtario(re_id);
--alter table PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido add foreign key (hv_medio_pago) references PROBASTE_REINICIANDO.BI_Dimension_MedioPago(mp_id);
alter table PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido add foreign key (hv_cat_prod) references PROBASTE_REINICIANDO.BI_Dimension_CategoriaProducto(cat_id);
alter table PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido add foreign key (hv_canal_venta) references PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta(cv_id);
alter table PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido add foreign key (hv_prod) references PROBASTE_REINICIANDO.BI_Dimension_Producto(prod_id);

insert into PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido(hv_tiempo, hv_clie_rangoetario, hv_canal_venta, hv_total, hv_prod, hv_precio, hv_cant, hv_cat_prod)
SELECT t_id, re_id, cv_id, SUM(item_v_cantidad) , dp.prod_id, AVG(item_v_precio), SUM(item_v_precio * item_v_cantidad), cat_id
from PROBASTE_REINICIANDO.Item_Venta
JOIN PROBASTE_REINICIANDO.Venta ON item_venta = venta_codigo
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo ON YEAR(venta_fecha) = t_ano and MONTH(venta_fecha) = t_mes
JOIN PROBASTE_REINICIANDO.Cliente ON venta_cliente = cliente_id
JOIN PROBASTE_REINICIANDO.BI_Dimension_RangoEtario ON DATEDIFF(hour,cliente_fecha_nac,GETDATE())/8766 >= re_limiteinf and DATEDIFF(hour,cliente_fecha_nac,GETDATE())/8766 < re_limitesup
JOIN PROBASTE_REINICIANDO.Canal_venta ON canal_id = venta_canal
JOIN PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta ON canal_tipo = cv_tipo
JOIN PROBASTE_REINICIANDO.Variante_Producto ON item_v_vproducto = variante_codigo
JOIN PROBASTE_REINICIANDO.Producto p ON variante_prod = p.prod_codigo
JOIN PROBASTE_REINICIANDO.BI_Dimension_Producto dp ON p.prod_nombre = dp.prod_nombre 
JOIN PROBASTE_REINICIANDO.Categoria_Producto ON catp_id = prod_categoria
JOIN PROBASTE_REINICIANDO.BI_Dimension_CategoriaProducto ON cat_desc = catp_desc
--JOIN PROBASTE_REINICIANDO.Medio_Pago_Venta ON venta_medio_pago = medio_venta_id
GROUP BY t_id, re_id, cv_id,dp.prod_id, cat_id


-- HECHO COMPRA
create table PROBASTE_REINICIANDO.BI_Hecho_Compra(
    hc_prov nvarchar(50) not null,
    hc_tiempo int not null,
    hc_prod nvarchar(50) not null,
    hc_precio decimal(18,2),
    hc_total decimal(18,2),
    hc_cantidad decimal(18,0)
    PRIMARY KEY(hc_prov, hc_tiempo, hc_prod)
);

alter table PROBASTE_REINICIANDO.BI_Hecho_Compra add foreign key (hc_prov) references PROBASTE_REINICIANDO.BI_Dimension_Proveedor(prov_cuit);
alter table PROBASTE_REINICIANDO.BI_Hecho_Compra add foreign key (hc_tiempo) references PROBASTE_REINICIANDO.BI_Dimension_Tiempo(t_id);
alter table PROBASTE_REINICIANDO.BI_Hecho_Compra add foreign key (hc_prod) references PROBASTE_REINICIANDO.BI_Dimension_Producto(prod_id);

insert into PROBASTE_REINICIANDO.BI_Hecho_Compra(hc_prov, hc_tiempo, hc_prod, hc_precio, hc_total, hc_cantidad)
SELECT dp.prov_cuit, t_id, prod_id, AVG(item_c_precio),SUM(item_c_precio * item_c_cantidad), SUM(item_c_cantidad)
from PROBASTE_REINICIANDO.Item_Compra
JOIN PROBASTE_REINICIANDO.Compra ON compra_codigo = item_compra
JOIN PROBASTE_REINICIANDO.Proveedor p ON compra_provee = p.prov_cuit
JOIN PROBASTE_REINICIANDO.BI_Dimension_Proveedor dp ON p.prov_cuit = dp.prov_cuit
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo ON YEAR(compra_fecha) = t_ano and MONTH(compra_fecha) = t_mes
JOIN PROBASTE_REINICIANDO.Variante_Producto ON variante_codigo = item_c_vproducto
JOIN PROBASTE_REINICIANDO.BI_Dimension_Producto ON variante_prod = prod_id
GROUP BY prod_id, t_id, dp.prov_cuit


-- HECHO ENVIO
create table PROBASTE_REINICIANDO.BI_Hecho_Envio(
    he_prov INT not null,
    he_tiempo int not null,
    he_tipo int not null,
    he_costo decimal(18,2),
	he_cantidad int not null,
    PRIMARY KEY(he_prov, he_tiempo, he_tipo)
);

ALTER TABLE PROBASTE_REINICIANDO.BI_Hecho_Envio ADD FOREIGN KEY (he_tipo) REFERENCES PROBASTE_REINICIANDO.BI_Dimension_Tipo_Envio(te_id);
ALTER TABLE PROBASTE_REINICIANDO.BI_Hecho_Envio ADD FOREIGN KEY (he_prov) REFERENCES PROBASTE_REINICIANDO.BI_Dimension_Provincia(provi_id);
ALTER TABLE PROBASTE_REINICIANDO.BI_Hecho_Envio ADD FOREIGN KEY (he_tiempo) REFERENCES PROBASTE_REINICIANDO.BI_Dimension_Tiempo(t_id);

INSERT INTO PROBASTE_REINICIANDO.BI_Hecho_Envio(he_prov, he_tiempo, he_tipo, he_costo, he_cantidad)
SELECT dp.provi_id, t_id , te_id, SUM(venta_costo_envio), COUNT(*)
from PROBASTE_REINICIANDO.Venta
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo ON YEAR(venta_fecha) = t_ano and MONTH(venta_fecha) = t_mes
JOIN PROBASTE_REINICIANDO.Tipo_Envio ON tipoenvio_id = venta_envio 
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tipo_Envio ON te_desc = tipoenvio_desc
JOIN PROBASTE_REINICIANDO.Cliente ON venta_cliente = cliente_id
JOIN PROBASTE_REINICIANDO.Provincia p ON cliente_provincia = provi_id
JOIN PROBASTE_REINICIANDO.BI_Dimension_Provincia dp ON p.provi_nombre = dp.provi_nombre
GROUP BY dp.provi_id, te_id, t_id
order by t_id


--HECHO DESCUENTO
CREATE TABLE PROBASTE_REINICIANDO.BI_Hecho_Descuento(
	hd_tipo int,
	hd_venta_canal int,
	hd_tiempo int ,
	hd_importe decimal (12,2)
	PRIMARY KEY(hd_tipo, hd_venta_canal, hd_tiempo)
); 

ALTER TABLE PROBASTE_REINICIANDO.BI_Hecho_Descuento ADD FOREIGN KEY (hd_tipo) REFERENCES PROBASTE_REINICIANDO.BI_Dimension_Tipo_Descuento_Venta(td_id);
ALTER TABLE PROBASTE_REINICIANDO.BI_Hecho_Descuento ADD FOREIGN KEY (hd_venta_canal) REFERENCES PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta(cv_id);
ALTER TABLE PROBASTE_REINICIANDO.BI_Hecho_Descuento ADD FOREIGN KEY (hd_tiempo) REFERENCES PROBASTE_REINICIANDO.BI_Dimension_Tiempo(t_id);

INSERT INTO PROBASTE_REINICIANDO.BI_Hecho_Descuento (hd_venta_canal,hd_tiempo, hd_tipo,hd_importe)
SELECT
cv_id,t_id,dtd.td_id, SUM(desc_v_valor) 
from PROBASTE_REINICIANDO.Descuento_Venta
JOIN PROBASTE_REINICIANDO.Tipo_Descuento td1 ON desc_v_tipo = td1.td_id
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tipo_Descuento_Venta dtd ON dtd.td_desc = td1.td_desc
JOIN PROBASTE_REINICIANDO.Venta ON desc_v_venta = venta_codigo
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo ON YEAR(venta_fecha) = t_ano and MONTH(venta_fecha) = t_mes
JOIN PROBASTE_REINICIANDO.Canal_venta ON canal_id = venta_canal
JOIN PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta ON canal_id = cv_id
GROUP BY dtd.td_id, cv_id, t_id
UNION
select 
cv_id, t_id, dtd.td_id,SUM(cupon_importe)
from PROBASTE_REINICIANDO.Venta
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tipo_Descuento_Venta dtd ON dtd.td_desc = 'cupon'
JOIN PROBASTE_REINICIANDO.Canal_venta ON canal_id = venta_canal
JOIN PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta ON canal_id = cv_id
join PROBASTE_REINICIANDO.Cupon_Venta on cv_venta = venta_codigo
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo ON YEAR(venta_fecha) = t_ano and MONTH(venta_fecha) = t_mes
group by cv_id, t_id, dtd.td_id

/*
Las ganancias mensuales de cada canal de venta.
Se entiende por ganancias al total de las ventas, menos el total de las
compras, menos los costos de transacción totales aplicados asociados los
medios de pagos utilizados en las mismas.
*/

GO
create view PROBASTE_REINICIANDO.ganancias_mensuales_canal_venta
as
(select cv_tipo, t1.t_mes, sum(v_total) - (select sum(hc_total) from PROBASTE_REINICIANDO.BI_Hecho_Compra 
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo t2 ON t2.t_mes = t1.t_mes) - sum(v_mp_costo) as ganancia
from PROBASTE_REINICIANDO.BI_Hecho_Venta
join PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta on cv_id = v_canal
join PROBASTE_REINICIANDO.BI_Dimension_Tiempo t1 on t1.t_id = v_tiempo
group by cv_tipo, t1.t_mes);


/*
Los 5 productos con mayor rentabilidad anual, con sus respectivos %
Se entiende por rentabilidad a los ingresos generados por el producto
(ventas) durante el periodo menos la inversión realizada en el producto
(compras) durante el periodo, todo esto sobre dichos ingresos.
Valor expresado en porcentaje.
Para simplificar, no es necesario tener en cuenta los descuentos aplicados.
*/
GO
create view PROBASTE_REINICIANDO.prods_con_mayor_rentabilidad_anual as
select TOP 5 
prod_nombre,
t1.t_ano,
str((sum(hv_total) - (SELECT SUM(hc_total) from PROBASTE_REINICIANDO.BI_Hecho_Compra JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo t2 ON t2.t_ano = t1.t_ano WHERE hc_prod = prod_id)) * 100-- * 100 /sum(hv_total)) 
/ ((sum(hv_total) + (SELECT SUM(hc_total) from PROBASTE_REINICIANDO.BI_Hecho_Compra JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo t2 ON t2.t_ano = t1.t_ano WHERE hc_prod = prod_id))),10,10)
+ '%'
as rentabilidad
from PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido
join PROBASTE_REINICIANDO.BI_Dimension_Tiempo t1 on t1.t_id = hv_tiempo
JOIN PROBASTE_REINICIANDO.BI_Dimension_Producto on hv_prod = prod_id
group by t_ano, prod_nombre, prod_id
order by 3;

/*
Las 5 categorías de productos más vendidos por rango etario de clientes 
por mes. 
*/

GO
create view PROBASTE_REINICIANDO.categorias_prod_mas_vendidos_mensual
as
(select t_ano as Ano, t_mes as Mes, 
CASE 
WHEN re_limiteinf = 0 THEN concat('<', str(re_limitesup,4,0))
WHEN re_limitesup = 1000 THEN concat('>', str(re_limiteinf, 4,0)) 
ELSE
str(re_limiteinf, 4,0) + ' - ' + str(re_limitesup,4,0)
END as Rango_Etario,
cat_desc as Categoria,
cant as Cantidad from (
    select t_mes,
           t_ano,
           cat_desc,
           re_limiteinf,
           re_limitesup,
           count(*) as cant,
           row_number() over (partition by t_mes order by count(*) desc) as mes_rank 
    from PROBASTE_REINICIANDO.BI_Hecho_Item_Vendido
    join PROBASTE_REINICIANDO.BI_Dimension_CategoriaProducto on hv_cat_prod = cat_id
    join PROBASTE_REINICIANDO.BI_Dimension_Tiempo on hv_tiempo = t_id
    join PROBASTE_REINICIANDO.BI_Dimension_RangoEtario on hv_clie_rangoetario = re_id
    group by cat_desc,re_limiteinf,re_limitesup, t_mes, t_ano
) ranks
where mes_rank <= 5);

/*
Total de Ingresos por cada medio de pago por mes, descontando los costos 
por medio de pago (en caso que aplique) y descuentos por medio de pago 
(en caso que aplique)
*/
GO
create view PROBASTE_REINICIANDO.ingresos_mediopago_mes
as
(select t1.t_mes as mes, mp_nombre as medioPago, sum(v_total) - sum(v_mp_costo) - sum(v_total_descuentos) as Ingresos
from PROBASTE_REINICIANDO.BI_Hecho_Venta
join PROBASTE_REINICIANDO.BI_Dimension_Tiempo t1 on t1.t_id = v_tiempo
join PROBASTE_REINICIANDO.BI_Dimension_MedioPago on v_mp = mp_id
group by t1.t_mes, mp_nombre);

/*
Importe total en descuentos aplicados según su tipo de descuento, por 
canal de venta, por mes.
Se entiende por tipo de descuento como los 
correspondientes a envío, medio de pago, cupones, etc) 
*/
GO
create view PROBASTE_REINICIANDO.importe_descuentos_aplicados_mensual
AS
(select SUM(hd_importe) as total, td_desc as tipoDescuento, cv_tipo as canalVenta, t_mes as mes from  PROBASTE_REINICIANDO.BI_Hecho_Descuento
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tipo_Descuento_Venta ON td_id = hd_tipo
JOIN PROBASTE_REINICIANDO.BI_Dimension_Canal_Venta ON cv_id = hd_venta_canal
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo ON t_id = hd_tiempo
GROUP BY td_desc, cv_tipo, t_mes);

/*
 Porcentaje de envíos realizados a cada Provincia por mes. El porcentaje 
debe representar la cantidad de envíos realizados a cada provincia sobre 
total de envío mensuales. 
*/
GO
create view PROBASTE_REINICIANDO.porcentaje_envios_a_provincias_mensual as
(select provi_nombre as provincia,  t1.t_mes as mes,
str((count(*) * 100 / 
(select count(*)
from PROBASTE_REINICIANDO.BI_Hecho_Envio a1
join PROBASTE_REINICIANDO.BI_Dimension_Tiempo a2 on a1.he_tiempo = a2.t_id
where a2.t_mes = t1.t_mes)),4,0) + '%' as porcentaje
from PROBASTE_REINICIANDO.BI_Hecho_Envio
join PROBASTE_REINICIANDO.BI_Dimension_Tiempo t1 on he_tiempo = t1.t_id
join PROBASTE_REINICIANDO.BI_Dimension_Provincia on he_prov = provi_id
group by provi_nombre, t1.t_mes);

/*
Valor promedio de envío por Provincia por Medio De Envío anual.
*/
GO
create view PROBASTE_REINICIANDO.valor_promedio_provincia_anual
as
(SELECT provi_nombre as provincia, te_desc as medio_envio, t_ano as año, AVG(he_costo/he_cantidad) as valor_promedio 
from PROBASTE_REINICIANDO.BI_Hecho_Envio
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo t on he_tiempo = t.t_id
JOIN PROBASTE_REINICIANDO.BI_Dimension_Provincia on he_prov = provi_id
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tipo_Envio on te_id = he_tipo
GROUP BY t.t_ano, provi_nombre, te_desc);

/*
Aumento promedio de precios de cada proveedor anual. 
Para calcular este indicador se debe tomar como referencia el máximo precio por año menos 
el mínimo todo esto divido el mínimo precio del año. Teniendo en cuenta 
que los precios siempre van en aumento.
*/
GO
create view PROBASTE_REINICIANDO.aumento_promedio_precio_proveedores_anual
as
(select t.t_ano as año, prov_cuit as proveedor, cast((max(hc_precio) - min(hc_precio)) / (
    SELECT MIN(h2.hc_precio) from PROBASTE_REINICIANDO.BI_Hecho_Compra h2
    JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo t2 on t.t_ano = t2.t_ano
) as decimal(18,5)) as aumento_promedio 
from PROBASTE_REINICIANDO.BI_Hecho_Compra c
JOIN PROBASTE_REINICIANDO.BI_Dimension_Proveedor p ON c.hc_prov = p.prov_cuit 
JOIN PROBASTE_REINICIANDO.BI_Dimension_Tiempo t on hc_tiempo = t.t_id
GROUP BY p.prov_cuit, t.t_ano);


/*
Los 3 productos con mayor cantidad de reposición por mes.
*/
GO
create view PROBASTE_REINICIANDO.prods_con_mas_reposicion_por_mes 
as
(select t_mes as mes, prod_nombre as producto, cant_reposicion from (
    select t_mes, 
           prod_nombre,
           sum(hc_cantidad) as cant_reposicion,
           row_number() over (partition by t_mes order by sum(hc_cantidad) desc) as mes_rank 
    from PROBASTE_REINICIANDO.BI_Hecho_Compra
    join PROBASTE_REINICIANDO.BI_Dimension_Tiempo on hc_tiempo = t_id
    join PROBASTE_REINICIANDO.BI_Dimension_Producto on hc_prod = prod_id
    group by prod_nombre, t_mes
) ranks
where mes_rank <= 3);

--select * from PROBASTE_REINICIANDO.ganancias_mensuales_canal_venta;
--select * from PROBASTE_REINICIANDO.prods_con_mayor_rentabilidad_anual;
--select * from PROBASTE_REINICIANDO.categorias_prod_mas_vendidos_mensual;
--select * from PROBASTE_REINICIANDO.ingresos_mediopago_mes;
--select * from PROBASTE_REINICIANDO.importe_descuentos_aplicados_mensual;
--select * from PROBASTE_REINICIANDO.porcentaje_envios_a_provincias_mensual;
--select * from PROBASTE_REINICIANDO.valor_promedio_provincia_anual;
--select * from PROBASTE_REINICIANDO.aumento_promedio_precio_proveedores_anual;
--select * from PROBASTE_REINICIANDO.prods_con_mas_reposicion_por_mes;