DROP VIEW IF EXISTS DIM_QUALITY_STANDARDS CASCADE;
CREATE OR REPLACE VIEW DIM_QUALITY_STANDARDS AS 
  SELECT metric_id, rule_name, 
    BOOL_OR(tag = 'AIP-TOP-PRIORITY') AS aip_top_priority,
    BOOL_OR(tag = 'OWASP-2017') AS owasp_2017,
    BOOL_OR(tag = 'CWE') AS cwe,
    BOOL_OR(tag = 'OMG-ASCQM') AS omg_ascqm 
  FROM std_rules 
  GROUP BY 1,2;