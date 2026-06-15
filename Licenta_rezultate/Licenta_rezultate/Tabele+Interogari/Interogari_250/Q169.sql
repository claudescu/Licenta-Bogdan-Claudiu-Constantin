-- Q169: Retururi web per produs și lună
SELECT i.i_category, i.i_brand, d.d_year, d.d_moy,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN date_dim d ON wr.wr_returned_date_sk = d.d_date_sk
GROUP BY i.i_category, i.i_brand, d.d_year, d.d_moy
ORDER BY pierdere_neta DESC
LIMIT 200;
