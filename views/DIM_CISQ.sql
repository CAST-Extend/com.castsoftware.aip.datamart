DROP VIEW IF EXISTS :schema.dim_cisq;
CREATE OR REPLACE VIEW :schema.dim_cisq AS 
  SELECT c.metric_id, c.rule_name, 
    BOOL_OR(c.tag = 'CISQ-Maintainability') AS cisq_maintainability,
    BOOL_OR(c.tag = 'CISQ-Performance-Efficiency') AS cisq_performance_efficiency,
    BOOL_OR(c.tag = 'CISQ-Reliability') AS cisq_reliability,
    BOOL_OR(c.tag = 'CISQ-Security') AS cisq_security
  FROM :schema.std_rules c 
  JOIN :schema.std_rules r on r.metric_id = c.metric_id and r.tag =  'CISQ'
  GROUP BY 1,2; 
 