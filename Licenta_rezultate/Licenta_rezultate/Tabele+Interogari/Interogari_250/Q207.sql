-- Q207: Retururi store per demografice client și produs
SELECT cd.cd_gender, cd.cd_education_status,
       i.i_category, s.s_store_name,
       COUNT(*) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       SUM(sr.sr_net_loss) AS pierdere_neta
FROM store_returns sr
JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk
JOIN item i ON sr.sr_item_sk = i.i_item_sk
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY cd.cd_gender, cd.cd_education_status, i.i_category, s.s_store_name
ORDER BY pierdere_neta DESC
LIMIT 100;
