-- Q133: Retururi store per motiv cu descriere
SELECT r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       AVG(sr.sr_return_amt) AS retur_mediu,
       SUM(sr.sr_net_loss) AS pierdere_totala
FROM store_returns sr
JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk
GROUP BY r.r_reason_desc
ORDER BY nr_retururi DESC;
