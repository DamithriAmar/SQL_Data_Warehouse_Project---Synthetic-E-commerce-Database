/*-------------------------------------------------------------------------------------------------
===================================================================================================

DDL Script: Create gold layer views

===================================================================================================

Script Purpose: Creates views for gold layer in the datawarehouse.
				Gold layer represents the final dimension and fact tables (Star Schema)
				
				Each view performs transformations and combines data from the silver layer.

-----------------------------------------------------------------------------------------------*/

--=================================================================================================
-- Create Dimention: gold.fact_customers
--=================================================================================================

IF OBJECT_ID('gold.fact_customers', 'V') IS NOT NULL
	DROP VIEW gold.fact_customers;
GO

CREATE VIEW gold.fact_customers AS
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	c.email,
	c.phone,
	c.country,
	c.city,
	c.signup_date,
	c. loyalty_tier,
	c.marketing_opt_in
FROM silver.customers AS c;
GO

--=================================================================================================
-- Create Dimention: gold.fact_products
--=================================================================================================

IF OBJECT_ID('gold.fact_products', 'V') IS NOT NULL
	DROP VIEW gold.fact_products;
GO

CREATE VIEW gold.fact_products AS
SELECT
	p.product_id,
	p.product_name,
	p.product_color,
	p.category,
	p.brand,
	p.unit_price,
	p.unit_cost,
	p.weight_kg,
	p.is_active,
	p.created_at
FROM silver.products AS p;
GO

--=================================================================================================
-- Create Dimention: gold.dim_sales
--=================================================================================================

IF OBJECT_ID('gold.dim_sales', 'V') IS NOT NULL
	DROP VIEW gold.dim_sales;
GO

CREATE VIEW gold.dim_sales AS
SELECT
	o.order_id,
	o.customer_id,
	oi.product_id,
	pm.payment_id,
	s.shipment_id,
	r.return_id,
	oi.quantity,
	oi.unit_price,
	oi.line_total,
	o.discount_amount,
	o.shipping_fee,
	o.tax_amount,
	o.subtotal AS order_subtotal,
	pm.amount AS payment_amount,
	o.order_date,
	o.channel AS order_channel,
	o.status AS order_status,
	pm.method AS payment_method,
	pm.paid_at AS payment_time,
	pm.status AS payment_status,
	s.carrier AS shipment_carrier,
	s.tracking_number AS shipment_tracking_num,
	s.shipped_at AS shipment_time,
	s.delivered_at AS delivery_time,
	s.status AS shipment_status,
	r.reason AS return_reason,
	r.refund_amount,
	r.requested_at AS return_request_time,
	r.status AS return_status
FROM silver.orders AS o
LEFT JOIN silver.order_items AS oi
ON o.order_id = oi.order_id
LEFT JOIN silver.payments AS pm
ON pm.order_id = o.order_id
LEFT JOIN silver.shipments AS s
ON s.order_id = o.order_id
LEFT JOIN silver.returns AS r
ON r.order_item_id = oi.order_item_id;
GO
