-- Q038: Rata de returnare per magazin (vânzări vs retururi)
SELECT s.s_store_name, s.s_state,
       COUNT(DISTINCT ss.ss_ticket_number) AS nr_vanzari,
       COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi,
       ROUND(
           CAST(COUNT(DISTINCT sr.sr_ticket_number) AS DECIMAL)
           / NULLIF(COUNT(DISTINCT ss.ss_ticket_number), 0) * 100, 2
       ) AS rata_returnare_pct
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
LEFT JOIN store_returns sr ON ss.ss_store_sk    = sr.sr_store_sk
                          AND ss.ss_ticket_number = sr.sr_ticket_number
GROUP BY s.s_store_name, s.s_state
ORDER BY rata_returnare_pct DESC;
