-- Q144: Vânzări catalog per brand și trimestru
SELECT i.i_brand, d.d_year, d.d_qoy,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
GROUP BY i.i_brand, d.d_year, d.d_qoy
ORDER BY d.d_year, d.d_qoy, total_vanzari DESC
LIMIT 200;
