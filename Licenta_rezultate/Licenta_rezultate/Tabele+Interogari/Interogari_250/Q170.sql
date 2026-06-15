-- Q170: Comparare prețuri vânzare vs preț de listă per magazin
SELECT s.s_store_name, s.s_state,
       AVG(ss.ss_sales_price) AS pret_mediu_vanzare,
       AVG(ss.ss_list_price) AS pret_mediu_lista,
       ROUND(AVG(ss.ss_sales_price) / NULLIF(AVG(ss.ss_list_price), 0) * 100, 2) AS pct_din_lista,
       COUNT(*) AS nr_tranzactii
FROM store_sales ss
JOIN store s ON ss.ss_store_sk = s.s_store_sk
GROUP BY s.s_store_name, s.s_state
ORDER BY pct_din_lista ASC;
