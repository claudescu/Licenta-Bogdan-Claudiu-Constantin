-- Q035: Vânzări per brand și zi a săptămânii
SELECT i.i_brand, d.d_day_name, d.d_dow,
       COUNT(*)               AS nr_tranzactii,
       SUM(ss.ss_net_paid)    AS total_vanzari,
       AVG(ss.ss_sales_price) AS pret_mediu
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY i.i_brand, d.d_day_name, d.d_dow
ORDER BY d.d_dow, total_vanzari DESC;
