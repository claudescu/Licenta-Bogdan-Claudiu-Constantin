-- Q153: Web retururi per an și trimestru
SELECT d.d_year, d.d_qoy,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta,
       AVG(wr.wr_return_quantity) AS cantitate_medie
FROM web_returns wr
JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
GROUP BY d.d_year, d.d_qoy
ORDER BY d.d_year, d.d_qoy;
