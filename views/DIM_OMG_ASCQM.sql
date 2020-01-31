DROP VIEW IF EXISTS :schema.dim_omg_ascqm;
CREATE OR REPLACE VIEW :schema.dim_omg_ascqm AS 
  SELECT c.metric_id, c.rule_name, 
    BOOL_OR(c.tag = 'OMG-ASCQM-Maintainability') AS omg_ascqm_maintainability,
    BOOL_OR(c.tag = 'OMG-ASCQM-Performance-Efficiency') AS omg_ascqm_performance_efficiency,
    BOOL_OR(c.tag = 'OMG-ASCQM-Reliability') AS omg_ascqm_reliability,
    BOOL_OR(c.tag = 'OMG-ASCQM-Security') AS omg_ascqm_security
  FROM :schema.std_rules c 
  JOIN :schema.std_rules r on r.metric_id = c.metric_id and r.tag =  'OMG-ASCQM'
  GROUP BY 1,2; 
 