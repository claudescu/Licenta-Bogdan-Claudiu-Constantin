-- Q108: Scoring complet client: vânzări + retururi + promoții + adresă + timp — 7 join-uri
WITH scor AS (
    SELECT c.c_customer_sk,
           SUM(ss.ss_net_paid)                    AS total_cumparat,
           COUNT(DISTINCT ss.ss_ticket_number) AS nr_comenzi,
           SUM(ss.ss_coupon_amt)               AS cupoane_folosite,
           COUNT(DISTINCT d.d_year)            AS ani_activi
    FROM store_sales ss
    JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
    JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
    JOIN store s    ON ss.ss_store_sk    = s.s_store_sk
    GROUP BY c.c_customer_sk
)
SELECT c.c_customer_id, ca.ca_state, ca.ca_city,
       cd.cd_gender, cd.cd_education_status,
       hd.hd_buy_potential, ib.ib_lower_bound,
       sc.total_cumparat, sc.nr_comenzi, sc.cupoane_folosite, sc.ani_activi,
       ROUND(sc.total_cumparat / NULLIF(sc.nr_comenzi, 0), 2) AS val_medie_comanda,
       NTILE(5) OVER (ORDER BY sc.total_cumparat DESC) AS quintila_ltv,
       RANK()   OVER (PARTITION BY ca.ca_state ORDER BY sc.total_cumparat DESC) AS rank_stat
FROM scor sc
JOIN customer c             ON sc.c_customer_sk   = c.c_customer_sk
JOIN customer_address ca    ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN income_band ib            ON hd.hd_income_band_sk = ib.ib_income_band_sk
ORDER BY sc.total_cumparat DESC
LIMIT 200;

-- ===========================================================
-- BLOC 15: INTEROGĂRI SUPLIMENTARE — 8–9 JOIN-URI (Q116–Q120)
-- ===========================================================
