-- Q027: Vânzare per band de venit al gospodăriei
SELECT hd.hd_buy_potential, hd.hd_dep_count, hd.hd_vehicle_count,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       AVG(ss.ss_sales_price)     AS pret_mediu
FROM store_sales ss
JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk
GROUP BY hd.hd_buy_potential, hd.hd_dep_count, hd.hd_vehicle_count
ORDER BY total_vanzari DESC;
