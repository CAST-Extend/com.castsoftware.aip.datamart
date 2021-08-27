DROP VIEW IF EXISTS :schema.datapond_patterns CASCADE;
CREATE OR REPLACE VIEW :schema.datapond_patterns AS 
SELECT 
    x.application_name AS appname,
    s.internal_id AS snapshot_id,
    s.date AS snapshot_date,
    x.metric_id AS metric_id,
    x.metric_name AS rule_name,
    sum(x.nb_findings) AS bookmark_count    
FROM :schema.app_violations_measures x
JOIN :schema.DIM_SNAPSHOTS s on s.SNAPSHOT_ID = x.snapshot_id
WHERE x.findings_type = 'bookmark'
GROUP BY 1,2,3,4,5
