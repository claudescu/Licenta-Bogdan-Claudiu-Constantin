-- Q139: Vânzări catalog per pagină catalog
SELECT cp.cp_department, cp.cp_type,
       COUNT(*) AS nr_tranzactii,
       SUM(cs.cs_net_paid) AS total_vanzari,
       SUM(cs.cs_net_profit) AS profit_total
FROM catalog_sales cs
JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
GROUP BY cp.cp_department, cp.cp_type
ORDER BY total_vanzari DESC;
