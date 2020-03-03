DROP VIEW IF EXISTS :schema.dim_owasp_2017 CASCADE;
CREATE OR REPLACE VIEW :schema.dim_owasp_2017 AS 
  SELECT c.metric_id, c.rule_name, 
    BOOL_OR(c.tag = 'A1-2017') AS a1_2017,
    BOOL_OR(c.tag = 'A2-2017') AS a2_2017,
    BOOL_OR(c.tag = 'A3-2017') AS a3_2017,
    BOOL_OR(c.tag = 'A4-2017') AS a4_2017,
    BOOL_OR(c.tag = 'A5-2017') AS a5_2017,
    BOOL_OR(c.tag = 'A6-2017') AS a6_2017,
    BOOL_OR(c.tag = 'A7-2017') AS a7_2017,
    BOOL_OR(c.tag = 'A8-2017') AS a8_2017,
    BOOL_OR(c.tag = 'A9-2017') AS a9_2017,
    BOOL_OR(c.tag = 'A10-2017') AS a10_2017
  FROM :schema.std_rules c 
  JOIN :schema.std_rules r on r.metric_id = c.metric_id and r.tag = 'OWASP-2017'
  GROUP BY 1,2;   