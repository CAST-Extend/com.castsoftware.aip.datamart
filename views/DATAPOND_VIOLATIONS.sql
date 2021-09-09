DROP VIEW IF EXISTS :schema.datapond_violations CASCADE;
CREATE OR REPLACE VIEW :schema.datapond_violations AS 
SELECT 
    application_name AS appname, 
    s.snapshot_number AS snapshot_id, 
    s.date AS snapshot_date,
    m.technology,
    r.business_criterion_id AS health_factor,
    r.technical_criterion_id AS tc_id,
    r.technical_criterion_name AS tc_name,
    r.technical_criterion_weight AS tc_weight,
    0 AS tc_critical,
    a.metric_id,
    r.rule_name AS metric_name, 
    r.weight::int AS metric_weight,
    r.is_critical::int AS metric_critical, 
    m.nb_total_checks AS checks,
    m.nb_total_checks - m.nb_violations AS successchecks,
    m.nb_violations AS total_violations,
    CASE WHEN m.nb_violations = m.nb_total_checks THEN 0 ELSE ROUND(m.nb_violations/(m.nb_total_checks - m.nb_violations), 2) END AS ratio,
    COALESCE(e.nb_violations_added, 0) AS added_violations,
    COALESCE(e.nb_violations_removed, 0) AS removed_violations,
    ROUND(a.score, 4) AS grade

FROM :schema.app_violations_measures m
JOIN :schema.dim_snapshots s ON s.snapshot_id = m.snapshot_id
JOIN :schema.dim_rules r ON r.rule_id = m.rule_id
JOIN :schema.app_scores a ON a.snapshot_id = m.snapshot_id AND m.metric_id = a.metric_id
LEFT JOIN :schema.app_violations_evolution e ON e.snapshot_id = m.snapshot_id AND e.metric_id = m.metric_id AND e.technology = m.technology
WHERE s.is_latest;



