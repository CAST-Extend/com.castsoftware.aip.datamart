DROP VIEW IF EXISTS :schema.app_iso_scores_view CASCADE;
CREATE OR REPLACE VIEW :schema.app_iso_scores_view
AS
SELECT s.application_name, s.snapshot_id,

MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Index'::text THEN m.nb_violations ELSE NULL::integer END) AS iso_index_violations,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Security'::text THEN m.nb_violations ELSE NULL::integer END) AS iso_security_violations,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Reliability'::text THEN m.nb_violations ELSE NULL::integer END) AS iso_reliability_violations,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Performance-Efficiency'::text THEN m.nb_violations ELSE NULL::integer END) AS iso_performance_violations,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Maintainability'::text THEN m.nb_violations ELSE NULL::integer END) AS iso_maintainability_violations,

MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Index'::text THEN m.remediation_effort ELSE NULL::integer END) AS iso_index_effort,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Security'::text THEN m.remediation_effort ELSE NULL::integer END) AS iso_security_effort,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Reliability'::text THEN m.remediation_effort ELSE NULL::integer END) AS iso_reliability_effort,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Performance-Efficiency'::text THEN m.remediation_effort ELSE NULL::integer END) AS iso_performance_effort,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Maintainability'::text THEN m.remediation_effort ELSE NULL::integer END) AS iso_maintainability_effort,

MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Index'::text THEN m.score ELSE NULL::numeric END) AS iso_index_score,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Security'::text THEN m.score ELSE NULL::numeric END) AS iso_security_score,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Reliability'::text THEN m.score ELSE NULL::numeric END) AS iso_reliability_score,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Performance-Efficiency'::text THEN m.score ELSE NULL::numeric END) AS iso_performance_score,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Maintainability'::text THEN m.score ELSE NULL::numeric END) AS iso_maintainability_score,

MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Index'::text THEN m.compliance_score ELSE NULL::numeric END) AS iso_index_compliance_score,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Security'::text THEN m.compliance_score ELSE NULL::numeric END) AS iso_security_compliance_score,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Reliability'::text THEN m.compliance_score ELSE NULL::numeric END) AS iso_reliability_compliance_score,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Performance-Efficiency'::text THEN m.compliance_score ELSE NULL::numeric END) AS iso_performance_compliance_score,
MAX(CASE WHEN m.business_criterion_name = 'ISO-5055-Maintainability'::text THEN m.compliance_score ELSE NULL::numeric END) AS iso_maintainability_compliance_score

FROM :schema.app_health_scores m
JOIN :schema.dim_snapshots s ON s.snapshot_id = m.snapshot_id AND s.is_latest 
WHERE m.business_criterion_name ~~ 'ISO%'::text
GROUP BY s.snapshot_id
ORDER BY s.application_name;
