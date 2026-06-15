-- Q199: Web vânzări per band de venit, gen și categorie
SELECT cd.cd_gender, hd.hd_buy_potential,
       ib.ib_lower_bound, ib.ib_upper_bound,
       i.i_category,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari
FROM web_sales ws
JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
GROUP BY cd.cd_gender, hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound, i.i_category
ORDER BY total_vanzari DESC
LIMIT 100;
