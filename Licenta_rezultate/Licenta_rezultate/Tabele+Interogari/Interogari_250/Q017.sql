-- Q017: Magazine cu vânzări mari (preț > 50) și taxă > 0%
SELECT s.s_store_name, s.s_state, s.s_tax_percentage,
       COUNT(ss.ss_ticket_number) AS nr_tranzactii,
       SUM(ss.ss_net_paid)        AS total_vanzari,
       SUM(ss.ss_net_profit)      AS profit_total
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
WHERE ss.ss_sales_price > 50 AND s.s_tax_percentage > 0
GROUP BY s.s_store_name, s.s_state, s.s_tax_percentage
ORDER BY profit_total DESC;
