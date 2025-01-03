--Dim tables

--**
--Calendar dim
DROP TABLE IF EXISTS Calendar CASCADE;
CREATE TABLE Calendar
(
 order_date date NOT NULL,
 ship_date date NOT NULL,
 year int NOT NULL,
 month int NOT NULL,
 day int NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY (order_date, ship_date)
);

INSERT INTO Calendar (order_date, ship_date, year, month, day)
	SELECT DISTINCT order_date, ship_date, DATE_PART('year', order_date) as year, DATE_PART('month', order_date) as month, DATE_PART('day', order_date) as day
	FROM orders_final_table;

SELECT * FROM Calendar

--**
--Product dim
DROP TABLE IF EXISTS Product_dim CASCADE;
CREATE TABLE Product_dim
(
 product_id varchar(50) NOT NULL,
 category varchar(30) NOT NULL,
 subcategory varchar(30) NOT NULL,
 product_name varchar(300) NOT NULL,
 CONSTRAINT PK_2 PRIMARY KEY (product_id, product_name)
);

INSERT INTO Product_dim (product_id, category, subcategory, product_name)
SELECT DISTINCT product_id, category, subcategory, product_name
FROM orders_final_table;

SELECT * FROM Product_dim

--**
--Shipping_dim
DROP TABLE IF EXISTS Shipping_dim CASCADE;
CREATE TABLE Shipping_dim
(
 shipping_id int NOT NULL,
 ship_mode varchar(30) NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY (shipping_id)
);

INSERT INTO Shipping_dim (shipping_id, ship_mode)
	SELECT ROW_NUMBER() OVER(), ship_mode from (SELECT DISTINCT(ship_mode) as ship_mode FROM orders_final_table);
SELECT * FROM Shipping_dim

--Customer table dim
DROP TABLE IF EXISTS Customer_dim CASCADE;
CREATE TABLE Customer_dim
(
 customer_id varchar(50) NOT NULL,
 customer_name varchar(300) NOT NULL,
 segment varchar(30) NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY (customer_id)
);

INSERT INTO Customer_dim (customer_id, customer_name, segment)
	SELECT DISTINCT customer_id, customer_name, segment
	FROM orders_final_table;

SELECT * from Customer_dim

--Geo table dim
DROP TABLE IF EXISTS Geo_dim CASCADE;
CREATE TABLE Geo_dim
(
 geo_id int NOT NULL,
 country varchar(30) NOT NULL,
 city varchar(30) NOT NULL,
 state varchar(30) NOT NULL,
 postal_code int,
 region varchar(30) NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY (geo_id)
);

INSERT INTO Geo_dim (geo_id, country, city, state, postal_code, region)
	SELECT ROW_NUMBER() OVER() as geo_id, country, city, state, postal_code, region
	FROM (SELECT DISTINCT country, city, state, postal_code, region FROM orders_final_table);

SELECT * from Geo_dim

--Facts table
DROP TABLE IF EXISTS SalesFact CASCADE;
CREATE TABLE SalesFact
(
 row_id int NOT NULL,
 order_id varchar(50) NOT NULL,
 order_date date NOT NULL,
 ship_date date NOT NULL,
 product_id varchar(50) NOT NULL,
 product_name varchar(300) NOT NULL,
 shipping_id int NOT NULL,
 customer_id varchar(50) NOT NULL,
 geo_id int NOT NULL,
 sales float4 NOT NULL,
 quantity int NOT NULL,
 discount float4 NOT NULL,
 profit float4 NOT NULL,
 returned varchar(10) NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY (row_id),
 CONSTRAINT FK_1 FOREIGN KEY ( order_date, ship_date ) REFERENCES Calendar ( order_date, ship_date ),
 CONSTRAINT FK_2 FOREIGN KEY ( product_id, product_name ) REFERENCES Product_dim ( product_id, product_name ),
 CONSTRAINT FK_3 FOREIGN KEY ( shipping_id ) REFERENCES Shipping_dim ( shipping_id ),
 CONSTRAINT FK_4 FOREIGN KEY ( customer_id ) REFERENCES Customer_dim ( customer_id ),
 CONSTRAINT FK_5 FOREIGN KEY ( geo_id ) REFERENCES Geo_dim ( geo_id )
);

CREATE INDEX FK_1 ON SalesFact
(
 order_date, ship_date
);

CREATE INDEX FK_2 ON SalesFact
(
 product_id, product_name
);

CREATE INDEX FK_3 ON SalesFact
(
 shipping_id
);

CREATE INDEX FK_4 ON SalesFact
(
 customer_id
);

CREATE INDEX FK_5 ON SalesFact
(
 geo_id
);

INSERT INTO SalesFact (row_id,
	order_id,
	order_date,
	ship_date,
	product_id,
	product_name,
	shipping_id,
	customer_id,
	geo_id,
	sales,
	quantity,
	discount,
	profit,
	returned)
SELECT 
	o.row_id,
	o.order_id,
	c.order_date,
	c.ship_date,
	p.product_id,
	p.product_name,
	sh.shipping_id,
	cus.customer_id,
	g.geo_id,
	o.sales,
	o.quantity,
	o.discount,
	o.profit,
	o.returned
FROM orders_final_table o
JOIN product_dim p ON o.product_id = p.product_id AND o.product_name = p.product_name
JOIN calendar c ON o.order_date = c.order_date AND o.ship_date = c.ship_date
JOIN shipping_dim sh ON o.ship_mode = sh.ship_mode
JOIN customer_dim cus ON o.customer_id = cus.customer_id
JOIN geo_dim g 
	ON o.country = g.country
	AND o.city = g.city
	AND o.state = g.state
	AND o.postal_code = g.postal_code
	AND o.region = g.region;
SELECT * FROM salesfact s order by row_id asc