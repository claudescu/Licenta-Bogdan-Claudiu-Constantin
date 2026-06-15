-- Q084: Retururi complete cu 8 join-uri: client, adresă, 2 demo, IB, produs, motiv, timp, magazin
SELECT s.s_store_name, s.s_state,
       r.r_reason_desc,
       i.i_category, i.i_brand,
       ca.ca_state, cd.cd_gender, cd.cd_credit_rating,
       hd.hd_buy_potential, ib.ib_lower_bound,
       d.d_year, d.d_qoy,
       COUNT(sr.sr_item_sk)  AS nr_retururi,
       SUM(sr.sr_return_amt) AS suma_returnata,
       SUM(sr.sr_net_loss)   AS pierdere_totala,
       RANK() OVER (PARTITION BY s.s_state, d.d_year ORDER BY SUM(sr.sr_net_loss) DESC) AS rank_pierdere_stat
FROM store_returns sr
JOIN store s                ON sr.sr_store_sk     = s.s_store_sk
JOIN item i                 ON sr.sr_item_sk      = i.i_item_sk
JOIN reason r               ON sr.sr_reason_sk    = r.r_reason_sk
JOIN customer c             ON sr.sr_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON sr.sr_cdemo_sk  = cd.cd_demo_sk
JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN date_dim d             ON sr.sr_returned_date_sk = d.d_date_sk
GROUP BY s.s_store_name, s.s_state, r.r_reason_desc, i.i_category, i.i_brand,
         ca.ca_state, cd.cd_gender, cd.cd_credit_rating,
         hd.hd_buy_potential, ib.ib_lower_bound, d.d_year, d.d_qoy
ORDER BY pierdere_totala DESC
LIMIT 100;
