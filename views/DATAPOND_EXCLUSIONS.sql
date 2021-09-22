DROP VIEW IF EXISTS :schema.datapond_exclusions CASCADE;
CREATE OR REPLACE VIEW :schema.datapond_exclusions AS 
SELECT 
    x.application_name AS appname,
    'Exclusions' AS exclusionbs,
    x.metric_id AS exclusions_metric_id,
    x.rule_name AS exclusions_metric_name,
    x.user_name AS exclusions_admin_id,
    x.comment AS exclusions_comments,
    s.snapshot_number AS exclusions_added_since_snapshot,
    count(*) AS count_of_exclusions,
    x.last_update_date AS last_updated_date
FROM :schema.usr_exclusions x
JOIN :schema.DIM_SNAPSHOTS s on s.SNAPSHOT_ID = x.exclusion_snapshot_id
GROUP BY 1,2,3,4,5,6,7,9

