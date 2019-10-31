CREATE OR REPLACE VIEW :schema.complete_flat AS 
  SELECT a.appname,
    a.yr_mth,
    s.application_id,
    s.label,
    a.snapshot,
    a.snapshot_date,
    a.snap_doy,
    a.locs,

    round((a.rbst_score + a.eff_score + a.sec_score) / 3::numeric, 2) AS operations,
    round((a.chg_score + a.trn_score) / 2::numeric, 2) AS maintenance,
    p.nb_total_points,
    p.nb_data_functions_points,
    p.nb_transactional_functions_points,


        CASE
		-- Fix any baseline data anomalies. AEP on the first snapshot is always bad. 
            WHEN s.snapshot_number = 1 AND b.nb_aep_total_points > p.nb_total_points THEN p.nb_total_points
            ELSE b.nb_aep_total_points 
        END AS aep,
        

    b.nb_aep_total_points AS raw_aep,
    b.nb_aep_points_added_functions,
    b.nb_aep_points_removed_functions,
    b.nb_aep_points_modified_functions,
    b.nb_aefp_total_points,
    b.nb_aefp_points_added,
    b.nb_aefp_points_removed,
    b.nb_aefp_points_modified,
    b.nb_aefp_data_function_points,
    b.nb_aefp_transactional_function_points,
    b.nb_aetp_total_points,
    b.nb_aetp_points_added,
    b.nb_aetp_points_removed,
    b.nb_aetp_points_modified,
    round(round(p.effort_complexity::numeric, 0),2) AS effort_complexity,
    
    --a.efp_added,
    --a.efp_deleted,
    --a.efp_modified,
    --a.efp,
    a.tech_debt_cur,
    a.tech_debt_add,
    a.tech_debt_rem,
    a.tech_debt_density,
    a.cvperafp,
    a.trn_score,
    a.trn_curr_cv,
    a.trn_added_cv,
    a.trn_removed_cv,
    a.trn_curr_vio,
    a.trn_add_vio,
    a.trn_rem_vio,
    a.chg_score,
    a.chg_curr_cv,
    a.chg_added_cv,
    a.chg_removed_cv,
    a.chg_curr_vio,
    a.chg_add_vio,
    a.chg_rem_vio,
    a.sec_score,
    a.sec_curr_cv,
    a.sec_added_cv,
    a.sec_removed_cv,
    a.sec_curr_vio,
    a.sec_add_vio,
    a.sec_rem_vio,
    a.rbst_score,
    a.rbst_curr_cv,
    a.rbst_added_cv,
    a.rbst_removed_cv,
    a.rbst_curr_vio,
    a.rbst_add_vio,
    a.rbst_rem_vio,
    a.eff_score,
    a.eff_curr_cv,
    a.eff_added_cv,
    a.eff_removed_cv,
    a.eff_curr_vio,
    a.eff_add_vio,
    a.eff_rem_vio,
    a.tqi_score,
    a.tqi_curr_cv AS cv_violations,
    a.tqi_removed_cv AS cv_violations_rem,
    a.tqi_added_cv * '-1'::integer AS cv_violations_add,
    a.tqi_curr_vio,
    a.tqi_add_vio * '-1'::integer AS vio_added,
    a.tqi_rem_vio AS vio_rem,
    a.tqi_rem_vio - a.tqi_add_vio AS net_vio,

   -- grab averages

          

    round((SELECT avg((f.tqi_rem_vio - f.tqi_add_vio)::numeric / NULLIF(e.nb_aep_total_points, 0)::numeric) AS avg
           FROM app_functional_sizing_evolution e, basedata_flat f, dim_snapshots s WHERE f.snapshot_date = s.date AND e.snapshot_id = s.snapshot_id AND s.application_name = f.appname AND f.snap_yr >= 2018 /* FOR TEST */
           AND f.tqi_curr_vio <> f.tqi_add_vio AND e.nb_aep_total_points > 50 ) * '-1'::integer::numeric, 3) AS avg_def_density,
          
    round((a.tqi_rem_vio - a.tqi_add_vio)::numeric / NULLIF(b.nb_aep_total_points, 0)::numeric, 3) AS raw_def_density,

    CASE
            WHEN (COALESCE((a.tqi_rem_vio - a.tqi_add_vio)::numeric / NULLIF(b.nb_aep_total_points, 0)::numeric / (( SELECT avg((e.tqi_rem_vio - e.tqi_add_vio)::numeric / NULLIF(f.nb_aep_total_points, 0)::numeric) AS avg
               FROM app_functional_sizing_evolution f, basedata_flat e, dim_snapshots s WHERE e.snapshot_date = s.date AND f.snapshot_id = s.snapshot_id AND s.application_name = e.appname AND e.snap_yr >= 2018 /* FOR TEST */
              AND e.tqi_curr_vio <> e.tqi_add_vio AND f.nb_aep_total_points > 50)) * '-1'::integer::numeric, 5.0) + 5::numeric) > 10::numeric THEN 10.0
            WHEN (COALESCE((a.tqi_rem_vio - a.tqi_add_vio)::numeric / NULLIF(b.nb_aep_total_points, 0)::numeric / (( SELECT avg((e.tqi_rem_vio - e.tqi_add_vio)::numeric / NULLIF(f.nb_aep_total_points, 0)::numeric) AS avg
               FROM app_functional_sizing_evolution f, basedata_flat e, dim_snapshots s WHERE e.snapshot_date = s.date AND f.snapshot_id = s.snapshot_id AND s.application_name = e.appname AND e.snap_yr >= 2018 /* FOR TEST */
              AND e.tqi_curr_vio <> e.tqi_add_vio AND f.nb_aep_total_points > 50)) * '-1'::integer::numeric, 5.0) + 5::numeric) < 1::numeric THEN 1.0
            WHEN ((a.tqi_rem_vio - a.tqi_add_vio)::numeric / NULLIF(b.nb_aep_total_points, 0)::numeric / (( SELECT avg((e.tqi_rem_vio - e.tqi_add_vio)::numeric / NULLIF(f.nb_aep_total_points, 0)::numeric) AS avg
               FROM app_functional_sizing_evolution f, basedata_flat e, dim_snapshots s WHERE e.snapshot_date = s.date AND f.snapshot_id = s.snapshot_id AND s.application_name = e.appname AND e.snap_yr >= 2018 /* FOR TEST */
              AND e.tqi_curr_vio <> e.tqi_add_vio AND f.nb_aep_total_points > 50)) * '-1'::integer::numeric) IS NULL THEN 5.0
              ELSE round((a.tqi_rem_vio - a.tqi_add_vio)::numeric / NULLIF(b.nb_aep_total_points, 0)::numeric / (( SELECT avg((e.tqi_rem_vio - e.tqi_add_vio)::numeric / NULLIF(f.nb_aep_total_points, 0)::numeric) AS avg
               FROM app_functional_sizing_evolution f, basedata_flat e, dim_snapshots s WHERE e.snapshot_date = s.date AND f.snapshot_id = s.snapshot_id AND s.application_name = e.appname AND e.snap_yr >= 2018 /* FOR TEST */
              AND e.tqi_curr_vio <> e.tqi_add_vio AND f.nb_aep_total_points > 50)) * '-1'::integer::numeric, 3) + 5::numeric
        END AS adjust_def_density,


    b.nb_aefp_points_added_data_functions,
    b.nb_aefp_points_added_transactional_functions,
    b.nb_aefp_points_removed_data_functions,
    b.nb_aefp_points_removed_transactional_functions,
    b.nb_aefp_points_modified_data_functions,
    b.nb_aefp_points_modified_transactional_functions,

    p.nb_transactions,
    b.nb_evolved_transactions,
    b.nb_enhanced_shared_artifacts,
    b.nb_enhanced_specific_artifacts,

    round(p.equivalence_ratio::numeric, 3) AS equivalent_ratio,
    round(round(b.nb_aefp_implementation_points::numeric,0),3) AS implementationpointsaefp,
    round(round(b.nb_aetp_implementation_points::numeric,0),3) AS implementationpointsaetp,
    d.nb_decision_points,

    round(a.locs / NULLIF(p.nb_transactions, 0)::numeric, 3) AS verbosity,

    round(( SELECT avg(g.locs / NULLIF(h.nb_transactions, 0)::numeric) AS avg
           FROM app_functional_sizing_measures h, basedata_flat g, dim_snapshots s 
          WHERE g.appname::text = a.appname::text AND s.application_name = g.appname and s.snapshot_id = h.snapshot_id and s.date = g.snapshot_date and g.snap_yr >= 2018 /* FOR TEST */), 3) AS avg_verbosity

--    split_part(a.appname::text, ' '::text, 2) AS motsid


 from dim_snapshots s
 join basedata_flat a on s.application_name = a.appname and s.date = a.snapshot_date
 join app_functional_sizing_measures p on s.snapshot_id = p.snapshot_id
 join app_functional_sizing_evolution b on s.snapshot_id = b.snapshot_id
 join app_sizing_measures d on d.snapshot_id = s.snapshot_id
 order by 1,5
;