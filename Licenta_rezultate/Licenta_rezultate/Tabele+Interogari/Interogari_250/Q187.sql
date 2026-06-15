-- Q187: Analiza retururi store per magazin, produs și motiv
SELECT s.s_store_name, i.i_category, r.r_reason_desc, d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       SUM(sr.sr_net_loss) AS pierdere_neta
FROM store_returns sr
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN item i ON sr.sr_item_sk = i.i_item_sk
JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk
JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY s.s_store_name, i.i_category, r.r_reason_desc, d.d_year
ORDER BY pierdere_neta DESC
LIMIT 100;
