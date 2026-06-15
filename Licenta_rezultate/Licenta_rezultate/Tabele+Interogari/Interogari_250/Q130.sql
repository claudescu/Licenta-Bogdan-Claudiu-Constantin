-- Q130: Retururi web per motiv
SELECT r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
GROUP BY r.r_reason_desc
ORDER BY nr_retururi DESC;
