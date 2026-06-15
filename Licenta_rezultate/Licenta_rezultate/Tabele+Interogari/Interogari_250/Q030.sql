-- Q030: Top produse per categorie după profit net total
SELECT i.i_category,
       i.i_product_name,
       i.i_brand,
       SUM(ss.ss_net_profit) AS profit_total,
       SUM(ss.ss_net_paid)   AS total_vanzari,
       COUNT(*)              AS nr_vanzari,
       RANK() OVER (PARTITION BY i.i_category ORDER BY SUM(ss.ss_net_profit) DESC) AS rank_in_categorie
FROM store_sales ss
JOIN item i ON ss.ss_item_sk = i.i_item_sk
GROUP BY i.i_category, i.i_product_name, i.i_brand
ORDER BY i.i_category, rank_in_categorie
LIMIT 100;

-- ===========================================================
-- BLOC 3: 2 JOIN-URI (Q031–Q045)
-- ===========================================================
