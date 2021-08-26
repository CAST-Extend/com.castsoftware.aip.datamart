DROP VIEW IF EXISTS :schema.datapond_ap CASCADE;
CREATE OR REPLACE VIEW :schema.datapond_ap AS 
SELECT 
    application_name AS appname, 
    'Action_Plan' as action_plans,
    object_id as object_id,
    object_name as object_name,
    object_full_name as object_fullname,
    metric_id as metric_id,
    rule_name as metric_name,
   	case  
		when priority = 'extreme' then 1 
		when priority = 'high' then 2 
		when priority = 'moderate' then 3
		when priority = 'low' then 4 
	end as priority,
    comment as comment
FROM :schema.usr_action_plan;



