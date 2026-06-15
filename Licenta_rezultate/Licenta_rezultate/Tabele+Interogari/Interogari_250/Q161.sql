-- Q161: Retururi store per produs cu rata de retur
SELECT i.i_product_name, i.i_category,
       COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi,
       SUM(sr.sr_return_amt) AS total_returnat,
       SUM(sr.sr_net_loss) AS pierdere_neta
FROM store_returns sr
JOIN item i ON sr.sr_item_sk = i.i_item_sk
GROUP BY i.i_product_name, i.i_category
ORDER BY nr_retururi DESC
LIMIT 100;
