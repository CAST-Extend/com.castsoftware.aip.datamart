DROP VIEW IF EXISTS :schema.datapond_patterns CASCADE;
CREATE OR REPLACE VIEW :schema.datapond_patterns AS 
SELECT 
    s.application_name AS appname,
    s.internal_id AS snapshot_id,
    s.date AS snapshot_date,
    x.metric_id AS metric_id,
    x.rule_name AS metric_name,
    sum(x.nb_findings) AS bookmark_count    
FROM :schema.app_findings_measures x
JOIN :schema.dim_snapshots s on s.snapshot_id = x.snapshot_id
WHERE x.finding_type = 'bookmark'
GROUP BY 1,2,3,4,5
