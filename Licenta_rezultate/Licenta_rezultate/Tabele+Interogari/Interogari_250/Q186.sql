-- Q186: Catalog vânzări per stat, brand, trimestru și depozit
SELECT ca.ca_state, i.i_brand, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY ca.ca_state, i.i_brand, d.d_year, d.d_qoy
ORDER BY total_vanzari DESC
LIMIT 200;
