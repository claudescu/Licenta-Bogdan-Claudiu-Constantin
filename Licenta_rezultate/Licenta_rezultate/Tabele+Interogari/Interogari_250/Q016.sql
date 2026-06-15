-- Q016: Vânzări cu denumirea reală a magazinului
SELECT s.s_store_name, s.s_city, s.s_state,
       COUNT(*)            AS nr_tranzactii,
       SUM(ss.ss_net_paid) AS total_incasat
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
GROUP BY s.s_store_name, s.s_city, s.s_state
ORDER BY total_incasat DESC;
