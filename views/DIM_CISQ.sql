DROP VIEW IF EXISTS dim_cisq CASCADE;
CREATE OR REPLACE VIEW dim_cisq AS 
  SELECT c.metric_id, c.rule_name, 
    BOOL_OR(c.tag = 'CISQ-Maintainability') AS cisq_maintainability,
    BOOL_OR(c.tag = 'CISQ-Performance-Efficiency') AS cisq_performance_efficiency,
    BOOL_OR(c.tag = 'CISQ-Reliability') AS cisq_reliability,
    BOOL_OR(c.tag = 'CISQ-Security') AS cisq_security
  FROM std_rules c 
  JOIN std_rules r on r.metric_id = c.metric_id and r.tag =  'CISQ'
  GROUP BY 1,2; 
 