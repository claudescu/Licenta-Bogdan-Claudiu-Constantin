-- Q138: Vânzări web per site
SELECT ws_site.web_name, ws_site.web_class, ws_site.web_manager,
       COUNT(*) AS nr_tranzactii,
       SUM(ws.ws_net_paid) AS total_vanzari,
       SUM(ws.ws_net_profit) AS profit_total
FROM web_sales ws
JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk
GROUP BY ws_site.web_name, ws_site.web_class, ws_site.web_manager
ORDER BY total_vanzari DESC;
