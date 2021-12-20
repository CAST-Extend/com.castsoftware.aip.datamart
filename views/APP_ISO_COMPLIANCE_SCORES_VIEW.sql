DROP VIEW IF EXISTS :schema.app_iso_compliance_scores_view  CASCADE;
CREATE OR REPLACE VIEW :schema.app_iso_compliance_scores_view AS 
WITH app_compliance_scores AS (
	SELECT m.snapshot_id, m.rule_id, sum(m.nb_violations)::decimal / SUM(m.nb_total_checks)::decimal AS score
	FROM :schema.app_violations_measures m 
	JOIN :schema.dim_snapshots s ON s.snapshot_id = m.snapshot_id AND s.is_latest
	GROUP BY m.snapshot_id, m.rule_id
),
app_compliance_scores_tc AS (
	select c.snapshot_id, r.technical_criterion_name,  
	CASE WHEN r.weight_omg_maintainability = 5 THEN 'maintainability'
	     WHEN r.weight_omg_efficiency = 5 THEN 'efficiency'
		 WHEN r.weight_omg_reliability = 5 THEN 'reliability'
		 WHEN r.weight_omg_security = 5 THEN 'security'
	END AS iso_index,
	AVG(c.score) AS score
	FROM :schema.dim_omg_rules r 
	JOIN :schema.app_compliance_scores c ON c.rule_id = r.rule_id
	GROUP BY c.snapshot_id, r.technical_criterion_name, 
	         r.weight_omg_maintainability,
			 r.weight_omg_efficiency,
			 r.weight_omg_reliability,
			 r.weight_omg_security
)
SELECT 
    s.application_name,
    AVG(CASE WHEN m.iso_index = 'security' THEN m.score ELSE NULL::decimal END) AS iso_5055_security,
    AVG(CASE WHEN m.iso_index = 'reliability' THEN m.score ELSE NULL::decimal END) AS iso_5055_reliability,
    AVG(CASE WHEN m.iso_index = 'efficiency' THEN m.score ELSE NULL::decimal END) AS iso_5055_efficiency,
    AVG(CASE WHEN m.iso_index = 'maintainability' THEN m.score ELSE NULL::decimal END) AS iso_5055_maitainability
FROM :schema.app_compliance_scores_tc m
JOIN :schema.dim_snapshots s ON s.snapshot_id = m.snapshot_id AND s.is_latest
GROUP BY s.snapshot_id;
