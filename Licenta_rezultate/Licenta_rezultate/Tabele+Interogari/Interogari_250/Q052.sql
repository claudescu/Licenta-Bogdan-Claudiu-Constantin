-- Q052: Rata de returnare per categorie, stat și gen client
SELECT i.i_category, s.s_state, cd.cd_gender,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_vanzari,
       COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi,
       ROUND(CAST(COUNT(DISTINCT sr.sr_ticket_number) AS DECIMAL)
             / NULLIF(COUNT(DISTINCT ss.ss_ticket_number), 0) * 100, 2) AS rata_retur_pct
FROM store_sales ss
JOIN item i                 ON ss.ss_item_sk    = i.i_item_sk
JOIN store s                ON ss.ss_store_sk   = s.s_store_sk
JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk
LEFT JOIN store_returns sr  ON ss.ss_item_sk      = sr.sr_item_sk
                           AND ss.ss_ticket_number = sr.sr_ticket_number
GROUP BY i.i_category, s.s_state, cd.cd_gender
ORDER BY rata_retur_pct DESC
LIMIT 100;
