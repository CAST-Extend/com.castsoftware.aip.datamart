DROP VIEW IF EXISTS :schema.datapond_basedata CASCADE;
CREATE OR REPLACE VIEW :schema.datapond_basedata AS 
WITH technologies AS (SELECT snapshot_id, string_agg(DISTINCT technology, ' ') AS technology FROM app_violations_measures GROUP BY 1)
SELECT 
   s.application_name AS appname, 
   t.technology AS technology,
   s.snapshot_id, 
   --(s.application_id*1000+s.snapshot_number) as snapshot_id, -- alternative pseudo snapshot_id as an integer
   
   s.date AS snapshot_date,
   z.nb_code_lines AS loc,

   f.nb_total_points AS afp,
   fe.nb_aefp_total_points AS efp,
   fe.nb_aefp_points_added AS added_efp,
   fe.nb_aefp_points_removed AS deleted_efp,
   fe.nb_aefp_points_modified AS modified_efp,

   z.technical_debt_total AS debt,
   d.technical_debt_added AS debt_added,
   d.technical_debt_deleted AS debt_removed,
   z.technical_debt_density AS debt_density,   

   h.business_criterion_name AS health_factor,
   round(h.score,4) AS hf_grade,
   
   h.nb_critical_violations AS total_cv,
   e.nb_critical_violations_added AS added_cv,
   e.nb_critical_violations_removed AS removed_cv,

   h.nb_violations AS total_violations,
   e.nb_violations_added AS added_violations,
   e.nb_violations_removed AS removed_violations

FROM dim_snapshots s

JOIN app_health_scores h ON h.snapshot_id = s.snapshot_id AND h.is_health_factor
JOIN app_health_evolution e ON e.snapshot_id = s.snapshot_id AND e.business_criterion_name = h.business_criterion_name

JOIN technologies t ON t.snapshot_id = s.snapshot_id

JOIN app_sizing_measures z ON z.snapshot_id = s.snapshot_id
JOIN app_sizing_evolution d ON d.snapshot_id = s.snapshot_id

JOIN app_functional_sizing_measures f ON f.snapshot_id = s.snapshot_id
JOIN app_functional_sizing_evolution fe ON fe.snapshot_id = s.snapshot_id;



