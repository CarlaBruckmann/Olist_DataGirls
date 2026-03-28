--1
SELECT 
  order_id,
  order_status,
  order_purchase_timestamp
FROM `sql-olist-datagirls.Database.olist_orders_dataset` 
ORDER BY order_purchase_timestamp ASC --garante 10 primeiros pedidos cronológicamente
LIMIT 10; -- limita a 10

--2
SELECT 
order_id,
order_purchase_timestamp,
order_delivered_customer_date
FROM `sql-olist-datagirls.Database.olist_orders_dataset`
WHERE order_status = "delivered"; --condicional

--3
SELECT
customer_unique_id,
customer_city
FROM `sql-olist-datagirls.Database.olist_customers_dataset`
WHERE customer_state = "SP";

--4
SELECT 
order_id,
product_id,
price 
FROM `sql-olist-datagirls.Database.olist_order_items_dataset`
WHERE price > 500;

--5
SELECT 
order_status,
COUNT(order_id) AS total_pedido_status
FROM `sql-olist-datagirls.Database.olist_orders_dataset`
GROUP BY order_status;

--6
SELECT 
payment_type,
SUM(payment_value) AS valor_total_pagamento
FROM `sql-olist-datagirls.Database.olist_order_payments_dataset`
GROUP BY payment_type;

--7
SELECT 
  AVG(valor_pedido) AS ticket_medio --média subquey
FROM (
  SELECT 
    order_id,
    SUM(payment_value) AS valor_pedido --soma os valores por id
  FROM `sql-olist-datagirls.Database.olist_order_payments_dataset`
  GROUP BY order_id
);

--8
SELECT 
  o.order_id,
  c.customer_city, --seleciona das tabelas → aliases para simplificar a leitura
  c.customer_state
FROM `sql-olist-datagirls.Database.olist_orders_dataset` AS o 
JOIN `sql-olist-datagirls.Database.olist_customers_dataset` AS c --junta as tabelas
  ON o.customer_id = c.customer_id; -- relação entre pedido e cliente

--9
SELECT 
  o.order_id,
  p.product_id, --seleciona das tabelas → aliases para simplificar a leitura
  p.price
FROM `sql-olist-datagirls.Database.olist_orders_dataset` AS o 
JOIN `sql-olist-datagirls.Database.olist_order_items_dataset` AS p --junta as tabelas
  ON o.order_id = p.order_id; -- relação entre pedido e produto

--10
SELECT 
  order_id,
  order_purchase_timestamp,
  order_delivered_customer_date,
  TIMESTAMP_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) AS tempo_entrega_dias --TIMESTAMP_DIFF(data_final, data_inicial, unidade)
FROM `sql-olist-datagirls.Database.olist_orders_dataset`
WHERE order_status = 'delivered';
