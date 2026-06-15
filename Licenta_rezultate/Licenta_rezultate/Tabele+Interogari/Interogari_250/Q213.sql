-- Q213: Analiza sezonalitate web vânzări per categorie și lună
WITH web_lunar AS (
    SELECT i.i_category, d.d_year, d.d_moy,
           SUM(ws.ws_net_paid) AS vanzari,
           COUNT(DISTINCT ws.ws_bill_customer_sk) AS clienti_unici,
           COUNT(*) AS nr_tranzactii
    FROM web_sales ws
    JOIN item i ON ws.ws_item_sk = i.i_item_sk
    JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
    JOIN web_site wst ON ws.ws_web_site_sk = wst.web_site_sk
    JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
    GROUP BY i.i_category, d.d_year, d.d_moy
)
SELECT i_category, d_year, d_moy, vanzari, clienti_unici, nr_tranzactii,
       LAG(vanzari) OVER (PARTITION BY i_category, d_year ORDER BY d_moy) AS vanzari_luna_prec
FROM web_lunar
ORDER BY i_category, d_year, d_moy;
