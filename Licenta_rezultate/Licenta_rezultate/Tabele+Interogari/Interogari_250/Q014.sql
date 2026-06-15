-- Q014: Raportul taxe / vânzări per magazin (procent efectiv taxare)
SELECT ss_store_sk,
       SUM(ss_ext_tax)         AS taxa_totala,
       SUM(ss_ext_sales_price) AS vanzari_brute,
       ROUND(
           SUM(ss_ext_tax) / NULLIF(SUM(ss_ext_sales_price), 0) * 100, 2
       ) AS procent_taxa
FROM store_sales
GROUP BY ss_store_sk
ORDER BY procent_taxa DESC;
