-- Q093: Analiza discounturilor per brand, zi și magazin
SELECT i.i_brand, d.d_day_name, s.s_store_name,
       COUNT(*)                       AS nr_tranzactii_cu_discount,
       SUM(ss.ss_ext_discount_amt)    AS discount_total,
       AVG(ss.ss_ext_discount_amt)    AS discount_mediu,
       SUM(ss.ss_net_paid)            AS total_vanzari_nete
FROM store_sales ss
JOIN item i     ON ss.ss_item_sk     = i.i_item_sk
JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
WHERE ss.ss_ext_discount_amt > 0
GROUP BY i.i_brand, d.d_day_name, s.s_store_name
ORDER BY discount_total DESC
LIMIT 100;

-- ===========================================================
-- BLOC 12: INTEROGĂRI SUPLIMENTARE — 4 JOIN-URI (Q101–Q105)
-- ===========================================================
