-- Q063: Sezonalitate vânzări: magazin + brand + weekend/holiday + oră
SELECT s.s_store_name, i.i_brand, d.d_weekend, d.d_holiday, t.t_hour,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk
GROUP BY s.s_store_name, i.i_brand, d.d_weekend, d.d_holiday, t.t_hour
ORDER BY total_vanzari DESC
LIMIT 200;
