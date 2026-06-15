-- Q159: Web vânzări per band de venit al gospodăriei
SELECT hd.hd_buy_potential, hd.hd_dep_count,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       AVG(ws.ws_sales_price) AS pret_mediu
FROM web_sales ws
JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
GROUP BY hd.hd_buy_potential, hd.hd_dep_count
ORDER BY total_vanzari DESC;
