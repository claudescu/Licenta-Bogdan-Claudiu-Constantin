-- Q214: Catalog vânzări per stat facturare, categorie și depozit
SELECT ca.ca_state, i.i_category, w.w_warehouse_name,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total,
       AVG(cs.cs_quantity) AS cantitate_medie
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk
GROUP BY ca.ca_state, i.i_category, w.w_warehouse_name
ORDER BY total_vanzari DESC
LIMIT 100;
