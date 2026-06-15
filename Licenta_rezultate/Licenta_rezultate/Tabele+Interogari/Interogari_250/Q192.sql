-- Q192: Web retururi per stat client, produs și motiv
SELECT ca.ca_state, i.i_category, r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN customer c ON wr.wr_returning_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
GROUP BY ca.ca_state, i.i_category, r.r_reason_desc
ORDER BY pierdere_neta DESC
LIMIT 100;
