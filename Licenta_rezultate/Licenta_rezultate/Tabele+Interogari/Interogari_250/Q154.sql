-- Q154: Produse vândute online dar niciodată în magazin
SELECT i.i_product_name, i.i_category, i.i_brand,
       COUNT(*) AS nr_vanzari_web,
       SUM(ws.ws_net_paid) AS total_web
FROM web_sales ws
JOIN item i ON ws.ws_item_sk = i.i_item_sk
WHERE NOT EXISTS (
    SELECT 1 FROM store_sales ss
    WHERE ss.ss_item_sk = i.i_item_sk
)
GROUP BY i.i_product_name, i.i_category, i.i_brand
ORDER BY total_web DESC
LIMIT 100;
