-- Q054: Produse cu marja mare per categorie
SELECT i.i_category, i.i_brand,
       COUNT(*)              AS nr_tranzactii,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk      = i.i_item_sk
JOIN store s    ON ss.ss_store_sk     = s.s_store_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
WHERE i.i_current_price > i.i_wholesale_cost * 1.5
  AND d.d_year = 2001
GROUP BY i.i_category, i.i_brand
ORDER BY profit_total DESC
LIMIT 100;
