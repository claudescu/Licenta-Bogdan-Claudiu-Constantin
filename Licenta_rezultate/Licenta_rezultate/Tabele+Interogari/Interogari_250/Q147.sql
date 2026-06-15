-- Q147: Retururi store per magazin și an
SELECT s.s_store_name, s.s_state, d.d_year,
       COUNT(*) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       SUM(sr.sr_net_loss) AS pierdere_neta
FROM store_returns sr
JOIN store s ON sr.sr_store_sk = s.s_store_sk
JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, d.d_year
ORDER BY pierdere_neta DESC;
