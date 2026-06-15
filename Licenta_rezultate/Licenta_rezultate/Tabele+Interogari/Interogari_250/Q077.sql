-- Q077: Analiza completă retururi cu client, adresă, produs, motiv, demografice și timp
SELECT r.r_reason_desc, i.i_category, i.i_brand,
       ca.ca_state, cd.cd_gender, cd.cd_credit_rating,
       d.d_year, d.d_qoy,
       COUNT(sr.sr_item_sk)  AS nr_retururi,
       SUM(sr.sr_return_amt) AS suma_returnata,
       SUM(sr.sr_net_loss)   AS pierdere_totala
FROM store_returns sr
JOIN customer c             ON sr.sr_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON sr.sr_cdemo_sk   = cd.cd_demo_sk
JOIN item i                 ON sr.sr_item_sk       = i.i_item_sk
JOIN reason r               ON sr.sr_reason_sk     = r.r_reason_sk
JOIN date_dim d             ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY r.r_reason_desc, i.i_category, i.i_brand,
         ca.ca_state, cd.cd_gender, cd.cd_credit_rating, d.d_year, d.d_qoy
ORDER BY pierdere_totala DESC
LIMIT 100;
