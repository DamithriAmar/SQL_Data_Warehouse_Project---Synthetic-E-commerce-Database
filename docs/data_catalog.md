# Data Catalog for Gold Layer

## 📊 Tables Overview

- [gold.dim_customers](#-golddim_customers) — Represents customer demographics and core profile tracking.
- [gold.dim_products](#-golddim_products) — Details product configurations, lines, and tracking classifications.
- [gold.fact_sales](#-goldfact_sales) — Tracks individual transactional line-item records.

---

## 👥 gold.fact_customers
> **Description:** Represents customer data.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `customer_id` | `INT` | **Surrogate key** Unique numerical identifier assigned to each customer. |
| `first_name` | `NVARCHAR(50)` | The customer's first name, as recorded in the system. |
| `last_name` | `NVARCHAR(50)` | The customer's last name or family name. |
| `email` | `NVARCHAR(50)` | The email for the customer. |
| `phone` | `NVARCHAR(50)` | The phone number of the customer. |
| `county ` | `NVARCHAR(50)` | The country of the customer. |
| `city` | `NVARCHAR(50)` | The city of residancy of customer. |
| `signup_date` | `DATE` | The date and time when the customer record was created in the system. |
| `loyalty_tier` | `VARCHAR(50)` | The loyalty tier the customer belongs to. (eg: silver, gold, none) |
| `marketing_opt_in` | `VARCHAR(50)` | If the customer subscribed for marketing information. |

[⬆ Back to top](#-tables-overview)

---

## 📦 gold.fact_products
> **Description:** Represents product data.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `product_id` | `INT` | **Surrogate key** uniquely identifying each product record in the product fact table. |
| `product_name` | `NVARCHAR(50)` | Descriptive name of the product, including key details such as type and size. |
| `product_color` | `VARCHAR(50)` | The colr of the product. |
| `category` | `NVARCHAR(50)` | A unique identifier for the product's category, linking to its high-level classification. |
| `brand` | `VARCHAR(50)` | The company of manufacturing of the product. |
| `unit_price` | `FLOAT` | Unit price of the product. |
| `unit_cost` | `FLOAT` | Unit cost of the product. |
| `weight_kg` | `FLOAT` | Weight of a unit product in kilograms. |
| `is_active` | `VARCHAR(50)` | If the product is still on sale. |
| `created_at` | `DATE` | The date when the product became available for sale or use, stored in the system. |

[⬆ Back to top](#-tables-overview)

---

## 💰 gold.dim_sales
> **Description:** Represents detailed sales transaction data, including order line items, pricing, payment details, shipment tracking, and return information.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `order_id` | `INT` | **Unique identifier** for the sales order. |
| `customer_id` | `INT` | **Foreign key** linking the order to the customer dimension table. |
| `product_id` | `INT` | **Foreign key** linking the line item to the product dimension table. |
| `payment_id` | `INT` | **Foreign key** linking the order to the payment transaction record. |
| `shipment_id` | `INT` | **Foreign key** linking the order to the shipment record. |
| `return_id` | `INT` | **Foreign key** linking the order to any associated return record. |
| `quantity` | `INT` | The number of units of the product ordered for the line item. |
| `unit_price` | `DECIMAL(10, 2)` | The price per single unit of the product at the time of purchase. |
| `line_total` | `DECIMAL(10, 2)` | The total monetary amount for the specific line item (`quantity` multiplied by `unit_price`). |
| `discount_amount` | `DECIMAL(10, 2)` | The total monetary discount applied to the order. |
| `shipping_fee` | `DECIMAL(10, 2)` | The shipping cost charged to the customer for the order. |
| `tax_amount` | `DECIMAL(10, 2)` | The total tax amount calculated for the order. |
| `order_subtotal` | `DECIMAL(10, 2)` | The total order amount before taxes, shipping fees, and discounts are applied. |
| `payment_amount` | `DECIMAL(10, 2)` | The actual monetary amount collected from the customer for the payment. |
| `order_date` | `DATE` | The date when the customer placed the order. |
| `order_channel` | `NVARCHAR(50)` | The sales channel where the order originated (e.g., 'Web', 'Mobile App', 'In-Store'). |
| `order_status` | `NVARCHAR(50)` | The current lifecycle status of the order (e.g., 'Pending', 'Completed', 'Cancelled'). |
| `payment_method` | `NVARCHAR(50)` | The method used to pay for the order (e.g., 'Credit Card', 'PayPal', 'Bank Transfer'). |
| `payment_time` | `DATETIME2` | The exact date and timestamp when the payment was successfully processed. |
| `payment_status` | `NVARCHAR(50)` | The processing status of the payment (e.g., 'Paid', 'Failed', 'Refunded'). |
| `shipment_carrier` | `NVARCHAR(50)` | The logistics provider or carrier handling the delivery (e.g., 'FedEx', 'UPS', 'DHL'). |
| `shipment_tracking_num` | `NVARCHAR(100)` | The unique tracking code provided by the carrier to monitor the package. |
| `shipment_time` | `DATETIME2` | The exact date and timestamp when the order was handed over to the carrier. |
| `delivery_time` | `DATETIME2` | The exact date and timestamp when the package was delivered to the customer. |
| `shipment_status` | `NVARCHAR(50)` | The current transit status of the shipment (e.g., 'In Transit', 'Delivered', 'Delayed'). |
| `return_reason` | `NVARCHAR(255)` | The reason provided by the customer for returning the item(s). |
| `refund_amount` | `DECIMAL(10, 2)` | The total monetary amount refunded to the customer for the return. |
| `return_request_time` | `DATETIME2` | The exact date and timestamp when the customer initiated the return request. |
| `return_status` | `NVARCHAR(50)` | The current processing status of the return (e.g., 'Requested', 'Approved', 'Refunded'). |

[⬆ Back to top](#-tables-overview)
