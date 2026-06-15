-- Q243: Store vânzări per gospodărie, magazin și categorie
SELECT hd.hd_buy_potential, hd.hd_dep_count, s.s_store_name, i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_vanzari,
       AVG(ss.ss_quantity) AS cantitate_medie
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
JOIN store s ON ss.ss_store_sk = s.s_store_sk
JOIN item i ON ss.ss_item_sk = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
GROUP BY hd.hd_buy_potential, hd.hd_dep_count, s.s_store_name, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
