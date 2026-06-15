-- Q110: LTV multi-canal + scoring complet cu TOATE dimensiunile — 9 join-uri
WITH ltv_store AS (
    SELECT ss.ss_customer_sk,
           SUM(ss.ss_net_paid)                    AS total_store,
           COUNT(DISTINCT ss.ss_ticket_number) AS comenzi_store,
           COUNT(DISTINCT ss.ss_store_sk)      AS magazine_vizitate,
           COUNT(DISTINCT ss.ss_item_sk)       AS produse_distincte
    FROM store_sales ss GROUP BY ss.ss_customer_sk
),
retururi AS (
    SELECT sr.sr_customer_sk,
           SUM(sr.sr_return_amt)               AS val_retururi,
           COUNT(DISTINCT sr.sr_ticket_number) AS nr_retururi
    FROM store_returns sr GROUP BY sr.sr_customer_sk
)
SELECT c.c_customer_id, c.c_first_name || ' ' || c.c_last_name AS nume,
       ca.ca_state, ca.ca_city, ca.ca_location_type,
       cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating,
       hd.hd_buy_potential, hd.hd_dep_count,
       ib.ib_lower_bound, ib.ib_upper_bound,
       ls.total_store, ls.comenzi_store, ls.magazine_vizitate, ls.produse_distincte,
       COALESCE(r.val_retururi, 0)  AS val_retururi,
       COALESCE(r.nr_retururi, 0)   AS nr_retururi,
       ROUND(COALESCE(r.val_retururi, 0) / NULLIF(ls.total_store, 0) * 100, 2) AS pct_returnat,
       ROUND(ls.total_store / NULLIF(ls.comenzi_store, 0), 2) AS val_medie_comanda,
       NTILE(5)     OVER (ORDER BY ls.total_store DESC) AS quintila,
       ROW_NUMBER() OVER (PARTITION BY ca.ca_state ORDER BY ls.total_store DESC) AS rank_in_stat,
       PERCENT_RANK() OVER (PARTITION BY cd.cd_education_status ORDER BY ls.total_store) AS percentila_edu
FROM ltv_store ls
JOIN customer c             ON ls.ss_customer_sk  = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
JOIN store_sales ss         ON c.c_customer_sk    = ss.ss_customer_sk
JOIN store s                ON ss.ss_store_sk     = s.s_store_sk
JOIN date_dim d             ON ss.ss_sold_date_sk = d.d_date_sk
LEFT JOIN retururi r        ON ls.ss_customer_sk  = r.sr_customer_sk
WHERE ls.total_store > 0
GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name,
         ca.ca_state, ca.ca_city, ca.ca_location_type,
         cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating,
         hd.hd_buy_potential, hd.hd_dep_count, ib.ib_lower_bound, ib.ib_upper_bound,
         ls.total_store, ls.comenzi_store, ls.magazine_vizitate, ls.produse_distincte,
         r.val_retururi, r.nr_retururi
ORDER BY ls.total_store DESC
LIMIT 200;
