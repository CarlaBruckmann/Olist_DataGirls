-- 1
SELECT
  order_id,
  DATE(order_delivered_customer_date)
    AS data_entrega,  -- data(sem considerar a hora)
  DATE(order_estimated_delivery_date) AS data_estimada,
  DATE_DIFF(
    DATE(order_delivered_customer_date),
    DATE(order_estimated_delivery_date),
    DAY) AS dias_atraso
FROM `sql-olist-datagirls.Database.olist_orders_dataset`
WHERE
  order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND DATE(order_delivered_customer_date) > DATE(order_estimated_delivery_date)
ORDER BY dias_atraso DESC;

-- 2
SELECT
  c.customer_unique_id,  -- seleciona das tabelas
  COUNT(o.order_id) AS pedidos  -- conta os pedidos
FROM `sql-olist-datagirls.Database.olist_orders_dataset` AS o
JOIN
  `sql-olist-datagirls.Database.olist_customers_dataset`
    AS c  -- junta as tabelas
  ON o.customer_id = c.customer_id  -- relação entre pedido e cliente
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1;  -- quantidade de pedidos >1

-- 3
SELECT
  c.customer_state,
  COUNT(o.order_id) AS pedidos  -- conta os pedidos
FROM `sql-olist-datagirls.Database.olist_orders_dataset` AS o
JOIN
  `sql-olist-datagirls.Database.olist_customers_dataset`
    AS c  -- junta as tabelas
  ON o.customer_id = c.customer_id  -- relação entre pedido e cliente
GROUP BY c.customer_state
ORDER BY pedidos DESC;

-- 4
SELECT
  AVG(review_score) AS media_avaliacao
FROM `sql-olist-datagirls.Database.olist_order_reviews_dataset`;

-- 5
SELECT
  c.customer_state,
  SUM(payment_value) AS receita_total
FROM `sql-olist-datagirls.Database.olist_order_payments_dataset` AS p
JOIN `sql-olist-datagirls.Database.olist_orders_dataset` AS o
  ON o.order_id = p.order_id
JOIN `sql-olist-datagirls.Database.olist_customers_dataset` AS c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY receita_total DESC;

-- 6
SELECT
  o.order_status,
  AVG(r.review_score) AS media_avaliacao
FROM `sql-olist-datagirls.Database.olist_order_reviews_dataset` AS r
JOIN `sql-olist-datagirls.Database.olist_orders_dataset` AS o
  ON r.order_id = o.order_id
GROUP BY o.order_status
ORDER BY media_avaliacao DESC;

-- 7
SELECT
  p.product_category_name,
  COUNT(o.order_item_id) AS total_itens  -- conta os itens pedidos
FROM `sql-olist-datagirls.Database.olist_order_items_dataset` AS o
JOIN
  `sql-olist-datagirls.Database.olist_products_dataset`
    AS p  -- junta as tabelas
  ON o.product_id = p.product_id  -- relação
GROUP BY p.product_category_name
ORDER BY total_itens DESC;

-- 8
SELECT
  p.product_category_name,
  AVG(o.freight_value) AS media_frete
FROM `sql-olist-datagirls.Database.olist_order_items_dataset` AS o
JOIN
  `sql-olist-datagirls.Database.olist_products_dataset`
    AS p  -- junta as tabelas
  ON o.product_id = p.product_id  -- relação
GROUP BY p.product_category_name
ORDER BY media_frete DESC;

-- 9
SELECT
  o.order_id,
  c.customer_state,
  DATE(o.order_purchase_timestamp) AS data_compra,
  SUM(oi.price) AS valor_total,  -- valor total
  SUM(oi.freight_value) AS frete_total,  -- frete
  COUNT(oi.order_item_id) AS quantidade_itens,  -- quantidade itens
  AVG(r.review_score)
    AS review_score  -- media score (caso tenha mais de 1 review por pedido)
FROM `sql-olist-datagirls.Database.olist_orders_dataset` AS o
JOIN `sql-olist-datagirls.Database.olist_customers_dataset` AS c
  ON o.customer_id = c.customer_id
JOIN `sql-olist-datagirls.Database.olist_order_items_dataset` AS oi
  ON o.order_id = oi.order_id
LEFT JOIN `sql-olist-datagirls.Database.olist_order_reviews_dataset` AS r
  ON o.order_id = r.order_id
GROUP BY
  o.order_id,
  c.customer_state,
  data_compra
ORDER BY data_compra DESC;
