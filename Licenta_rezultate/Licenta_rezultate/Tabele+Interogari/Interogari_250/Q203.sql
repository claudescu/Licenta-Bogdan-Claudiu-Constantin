-- Q203: Web retururi per site, produs și motiv
SELECT ws_site.web_name, i.i_category, r.r_reason_desc,
       COUNT(*) AS nr_retururi,
       SUM(wr.wr_return_amt) AS total_returnat,
       SUM(wr.wr_net_loss) AS pierdere_neta
FROM web_returns wr
JOIN web_sales ws ON wr.wr_item_sk = ws.ws_item_sk AND wr.wr_order_number = ws.ws_order_number
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN item i ON wr.wr_item_sk = i.i_item_sk
JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk
GROUP BY ws_site.web_name, i.i_category, r.r_reason_desc
ORDER BY pierdere_neta DESC
LIMIT 100;
