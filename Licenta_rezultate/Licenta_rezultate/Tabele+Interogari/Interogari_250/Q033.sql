-- Q033: Vânzări per categorie produs și an
SELECT i.i_category, d.d_year,
       COUNT(*)              AS nr_vanzari,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       SUM(ss.ss_net_profit) AS profit_total,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_category, d.d_year
ORDER BY i.i_category, d.d_year;
