-- Q090: Clienți care cumpără exclusiv în weekend per categorie
SELECT i.i_category, d.d_weekend,
       COUNT(DISTINCT ss.ss_customer_sk) AS clienti_unici,
       COUNT(*)                          AS nr_tranzactii,
       SUM(ss.ss_net_paid)               AS total_vanzari
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN customer c ON ss.ss_customer_sk  = c.c_customer_sk
GROUP BY i.i_category, d.d_weekend
ORDER BY total_vanzari DESC;
