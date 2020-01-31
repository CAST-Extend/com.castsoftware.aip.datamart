DROP VIEW IF EXISTS :schema.basedata_flat CASCADE;
CREATE OR REPLACE VIEW :schema.basedata_flat AS 
 SELECT 
    s.snapshot_id,
    a.application_name as appname,

    (date_part('year'::text, s.date) || lpad(date_part('month'::text, s.date)::text, 2, '0'::text))::integer AS yr_mth,  
    max(s.snapshot_number) AS snapshot, 
    s.date as snapshot_date,
    date_part('month'::text, s.date)::integer AS snap_mth, 
    date_part('quarter'::text, s.date)::integer AS snap_qtr, 
    date_part('year'::text, s.date)::integer AS snap_yr, 
    date_part('doy'::text, s.date)::integer AS snap_doy, 
    max(f.nb_total_points) AS curr_afp, 

    round(max(m.technical_debt_total)::numeric,2) AS tech_debt_cur,
    round(max(e.technical_debt_added)::numeric,2) as tech_debt_add,    
    round(max(e.technical_debt_deleted)::numeric,2) as tech_debt_rem,         
    round(max(m.technical_debt_density)::numeric,2) AS tech_debt_density,
     
    max(round(m.nb_critical_violations / NULLIF(f.nb_total_points, 0)::numeric,3)) AS cvperafp, 
    max(m.nb_code_lines) as locs,
    max(m.nb_violations_excluded) AS excluded_vio,
    max(m.nb_violations_fixed_action_plan) AS ap_fixed_vio,
    max(m.nb_violations_pending_action_plan) AS ap_pending_vio,
    
    max(CASE
          WHEN h.business_criterion_name = 'Transferability'::text THEN round(cast(h.score as numeric),4)
          ELSE NULL::numeric
    END) AS trn_score,
    max(
       CASE
           WHEN h.business_criterion_name  = 'Transferability'::text THEN h.nb_critical_violations
           ELSE NULL::integer
       END) AS trn_curr_cv,
    max(
       CASE
           WHEN e1.business_criterion_name  = 'Transferability'::text THEN e1.nb_critical_violations_added
           ELSE NULL::integer
       END) AS trn_added_cv,      
    max(
       CASE
           WHEN e1.business_criterion_name  = 'Transferability'::text THEN e1.nb_critical_violations_removed
           ELSE NULL::integer
       END) AS trn_removed_cv,   
    max(
       CASE
           WHEN h.business_criterion_name  = 'Transferability'::text THEN h.nb_violations
           ELSE NULL::integer
       END) AS trn_curr_vio,
    max(
       CASE
           WHEN e1.business_criterion_name  = 'Transferability'::text THEN e1.nb_violations_added
           ELSE NULL::integer
       END) AS trn_add_vio,      
    max(
       CASE
           WHEN e1.business_criterion_name  = 'Transferability'::text THEN e1.nb_violations_removed
           ELSE NULL::integer
       END) AS trn_rem_vio,
    max(CASE
          WHEN h.business_criterion_name = 'Changeability'::text THEN round(cast(h.score as numeric),4)
          ELSE NULL::numeric
    END) AS chg_score,
    max(
       CASE
           WHEN h.business_criterion_name  = 'Changeability'::text THEN h.nb_critical_violations
           ELSE NULL::integer
       END) AS chg_curr_cv,
    max(
       CASE
           WHEN e1.business_criterion_name  = 'Changeability'::text THEN e1.nb_critical_violations_added
           ELSE NULL::integer
       END) AS chg_added_cv,      
    max(
       CASE
           WHEN e1.business_criterion_name  = 'Changeability'::text THEN e1.nb_critical_violations_removed
           ELSE NULL::integer
       END) AS chg_removed_cv,   
    max(
       CASE
           WHEN h.business_criterion_name  = 'Changeability'::text THEN h.nb_violations
           ELSE NULL::integer
       END) AS chg_curr_vio,
    max(
       CASE
           WHEN e1.business_criterion_name  = 'Changeability'::text THEN e1.nb_violations_added
           ELSE NULL::integer
       END) AS chg_add_vio,      
    max(
       CASE
           WHEN e1.business_criterion_name  = 'Changeability'::text THEN e1.nb_violations_removed
           ELSE NULL::integer
       END) AS chg_rem_vio,
     max(CASE
          WHEN h.business_criterion_name = 'Security'::text THEN round(cast(h.score as numeric),4)
          ELSE NULL::numeric
    END) AS sec_score,
    max(
        CASE
            WHEN h.business_criterion_name  = 'Security'::text THEN h.nb_critical_violations
            ELSE NULL::integer
        END) AS sec_curr_cv,
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Security'::text THEN e1.nb_critical_violations_added
            ELSE NULL::integer
        END) AS sec_added_cv,      
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Security'::text THEN e1.nb_critical_violations_removed
            ELSE NULL::integer
        END) AS sec_removed_cv,   
    max(
        CASE
            WHEN h.business_criterion_name  = 'Security'::text THEN h.nb_violations
            ELSE NULL::integer
        END) AS sec_curr_vio,
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Security'::text THEN e1.nb_violations_added
            ELSE NULL::integer
        END) AS sec_add_vio,      
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Security'::text THEN e1.nb_violations_removed
            ELSE NULL::integer
        END) AS sec_rem_vio,
    max(CASE
            WHEN h.business_criterion_name = 'Robustness'::text THEN round(cast(h.score as numeric),4)
            ELSE NULL::numeric
     END) AS rbst_score,
    max(
        CASE
            WHEN h.business_criterion_name  = 'Robustness'::text THEN h.nb_critical_violations
            ELSE NULL::integer
        END) AS rbst_curr_cv,
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Robustness'::text THEN e1.nb_critical_violations_added
            ELSE NULL::integer
        END) AS rbst_added_cv,      
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Robustness'::text THEN e1.nb_critical_violations_removed
            ELSE NULL::integer
        END) AS rbst_removed_cv,   
    max(
        CASE
            WHEN h.business_criterion_name  = 'Robustness'::text THEN h.nb_violations
            ELSE NULL::integer
        END) AS rbst_curr_vio,
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Robustness'::text THEN e1.nb_violations_added
            ELSE NULL::integer
        END) AS rbst_add_vio,      
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Robustness'::text THEN e1.nb_violations_removed
            ELSE NULL::integer
        END) AS rbst_rem_vio,
    max(CASE
            WHEN h.business_criterion_name = 'Efficiency'::text THEN round(cast(h.score as numeric),4)
            ELSE NULL::numeric
        END) AS eff_score,
    max(
        CASE
            WHEN h.business_criterion_name  = 'Efficiency'::text THEN h.nb_critical_violations
            ELSE NULL::integer
        END) AS eff_curr_cv,
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Efficiency'::text THEN e1.nb_critical_violations_added
            ELSE NULL::integer
        END) AS eff_added_cv,      
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Efficiency'::text THEN e1.nb_critical_violations_removed
            ELSE NULL::integer
        END) AS eff_removed_cv,   
    max(
        CASE
            WHEN h.business_criterion_name  = 'Efficiency'::text THEN h.nb_violations
            ELSE NULL::integer
        END) AS eff_curr_vio,
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Efficiency'::text THEN e1.nb_violations_added
            ELSE NULL::integer
        END) AS eff_add_vio,      
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Efficiency'::text THEN e1.nb_violations_removed
            ELSE NULL::integer
        END) AS eff_rem_vio,
    max(CASE
           WHEN h.business_criterion_name = 'Total Quality Index'::text THEN round(cast(h.score as numeric),4)
           ELSE NULL::numeric
    END) AS tqi_score,
    max(
        CASE
            WHEN h.business_criterion_name  = 'Total Quality Index'::text THEN h.nb_critical_violations
            ELSE NULL::integer
        END) AS tqi_curr_cv,
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Total Quality Index'::text THEN e1.nb_critical_violations_added
            ELSE NULL::integer
        END) AS tqi_added_cv,      
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Total Quality Index'::text THEN e1.nb_critical_violations_removed
            ELSE NULL::integer
        END) AS tqi_removed_cv,   
    max(
        CASE
            WHEN h.business_criterion_name  = 'Total Quality Index'::text THEN h.nb_violations
            ELSE NULL::integer
        END) AS tqi_curr_vio,
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Total Quality Index'::text THEN e1.nb_violations_added
            ELSE NULL::integer
        END) AS tqi_add_vio,      
    max(
        CASE
            WHEN e1.business_criterion_name  = 'Total Quality Index'::text THEN e1.nb_violations_removed
            ELSE NULL::integer
        END) AS tqi_rem_vio
 from :schema.dim_snapshots s
 join :schema.dim_applications a on a.application_name = s.application_name
 left join :schema.app_sizing_measures m on m.snapshot_id = s.snapshot_id
 left join :schema.app_sizing_evolution e on e.snapshot_id = s.snapshot_id
 left join :schema.app_functional_sizing_measures f on f.snapshot_id = s.snapshot_id
 left join :schema.app_health_scores h on h.snapshot_id = s.snapshot_id
 left join :schema.app_health_evolution e1 on e1.snapshot_id = s.snapshot_id
 group by a.application_name, s.snapshot_id
 order by a.application_name, s.snapshot_id
 ;
