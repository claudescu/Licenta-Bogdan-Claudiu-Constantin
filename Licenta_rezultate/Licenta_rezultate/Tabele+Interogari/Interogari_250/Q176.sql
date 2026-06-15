-- Q176: Web vânzări per site și an
SELECT ws_site.web_name, ws_site.web_market_manager, d.d_year,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
GROUP BY ws_site.web_name, ws_site.web_market_manager, d.d_year
ORDER BY d.d_year, total_vanzari DESC;
