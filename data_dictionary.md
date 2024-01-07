## Data Dictionary
- [APP_FINDINGS_MEASURES](#APP_FINDINGS_MEASURES)
- [APP_FUNCTIONAL_SIZING_EVOLUTION](#APP_FUNCTIONAL_SIZING_EVOLUTION)
- [APP_FUNCTIONAL_SIZING_MEASURES](#APP_FUNCTIONAL_SIZING_MEASURES)
- [APP_HEALTH_EVOLUTION](#APP_HEALTH_EVOLUTION)
- [APP_HEALTH_SCORES](#APP_HEALTH_SCORES)
- [APP_SCORES](#APP_SCORES)
- [APP_SIZING_EVOLUTION](#APP_SIZING_EVOLUTION)
- [APP_SIZING_MEASURES](#APP_SIZING_MEASURES)
- [APP_TECHNO_SCORES](#APP_TECHNO_SCORES)
- [APP_TECHNO_SIZING_EVOLUTION](#APP_TECHNO_SIZING_EVOLUTION)
- [APP_TECHNO_SIZING_MEASURES](#APP_TECHNO_SIZING_MEASURES)
- [APP_VIOLATIONS_EVOLUTION](#APP_VIOLATIONS_EVOLUTION)
- [APP_VIOLATIONS_MEASURES](#APP_VIOLATIONS_MEASURES)
- [DIM_APPLICATIONS](#DIM_APPLICATIONS)
- [DIM_CISQ_RULES](#DIM_CISQ_RULES)
- [DIM_OMG_RULES](#DIM_OMG_RULES)
- [DIM_QUALITY_STANDARDS](#DIM_QUALITY_STANDARDS)
- [DIM_RULES](#DIM_RULES)
- [DIM_SNAPSHOTS](#DIM_SNAPSHOTS)
- [MOD_HEALTH_EVOLUTION](#MOD_HEALTH_EVOLUTION)
- [MOD_HEALTH_SCORES](#MOD_HEALTH_SCORES)
- [MOD_SCORES](#MOD_SCORES)
- [MOD_SIZING_EVOLUTION](#MOD_SIZING_EVOLUTION)
- [MOD_SIZING_MEASURES](#MOD_SIZING_MEASURES)
- [MOD_TECHNO_SCORES](#MOD_TECHNO_SCORES)
- [MOD_TECHNO_SIZING_EVOLUTION](#MOD_TECHNO_SIZING_EVOLUTION)
- [MOD_TECHNO_SIZING_MEASURES](#MOD_TECHNO_SIZING_MEASURES)
- [MOD_VIOLATIONS_EVOLUTION](#MOD_VIOLATIONS_EVOLUTION)
- [MOD_VIOLATIONS_MEASURES](#MOD_VIOLATIONS_MEASURES)
- [SRC_HEALTH_IMPACTS](#SRC_HEALTH_IMPACTS)
- [SRC_MOD_OBJECTS](#SRC_MOD_OBJECTS)
- [SRC_OBJECTS](#SRC_OBJECTS)
- [SRC_TRANSACTIONS](#SRC_TRANSACTIONS)
- [SRC_TRX_HEALTH_IMPACTS](#SRC_TRX_HEALTH_IMPACTS)
- [SRC_TRX_OBJECTS](#SRC_TRX_OBJECTS)
- [SRC_VIOLATIONS](#SRC_VIOLATIONS)
- [STD_DESCRIPTIONS](#STD_DESCRIPTIONS)
- [STD_RULES](#STD_RULES)
- [USR_ACTION_PLAN](#USR_ACTION_PLAN)
- [USR_EXCLUSIONS](#USR_EXCLUSIONS)

### APP_FINDINGS_MEASURES
Count of violations findings for the most recent snapshot only. Skip rules that have been deactivated or detached.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
metric_id                            | INT      | AIP Globally unique metric ID
technology                           | TEXT     | Source code technology
finding_type                         | TEXT     | Type of finding among ["number", "percentage", "text", "object", "date", "integer", "no-value", "path", "group", "bookmark"]
nb_findings                          | INT      | Total number of findings associated to this rule ; for example the number of bookmarks, number of paths, number of objects
```

### APP_FUNCTIONAL_SIZING_EVOLUTION
Automatic Enhancement Points by application snapshot
```
COLUMN                                         | TYPE     | DESCRIPTION
-----------------------------------------------+----------+------------
snapshot_id                                    | TEXT     | The concatenation of the application name and the snapshot timestamp
previous_snapshot_id                           | TEXT     | The concatenation of the application name and the snapshot timestamp
nb_aefp_data_function_points                   | INT      | (Metric #10431) AEP Measure
nb_aefp_implementation_points                  | DECIMAL  | (Metric #10360) AEP Measure
nb_aefp_points_added_data_functions            | INT      | (Metric #10401) AEP Measure
nb_aefp_points_added_transactional_functions   | INT      | (Metric #10402) AEP Measure
nb_aefp_points_modified_data_functions         | INT      | (Metric #10421) AEP Measure
nb_aefp_points_modified_transactional_functions| INT      | (Metric #10422) AEP Measure
nb_aefp_points_removed_data_functions          | INT      | (Metric #10411) AEP Measure
nb_aefp_points_removed_transactional_functions | INT      | (Metric #10412) AEP Measure
nb_aefp_points_added                           | INT      | (Metric #10400) AEP Measure
nb_aefp_points_removed                         | INT      | (Metric #10410) AEP Measure
nb_aefp_points_modified                        | INT      | (Metric #10420) AEP Measure
nb_aefp_total_points                           | INT      | (Metric #10430) AEP Measure
nb_aefp_transactional_function_points          | INT      | (Metric #10432) AEP Measure
nb_aep_points_added_functions                  | INT      | (Metric #10451) AEP Measure
nb_aep_points_modified_functions               | INT      | (Metric #10453) AEP Measure
nb_aep_points_removed_functions                | INT      | (Metric #10452) AEP Measure
nb_aetp_points_added                           | INT      | (Metric #10441) AEP Measure
nb_aetp_points_removed                         | INT      | (Metric #10442) AEP Measure
nb_aetp_points_modified                        | INT      | (Metric #10443) AEP Measure
nb_aep_total_points                            | INT      | (Metric #10450) AEP Measure
nb_aetp_implementation_points                  | DECIMAL  | (Metric #10362) AEP Measure
nb_aetp_total_points                           | INT      | (Metric #10440) AEP Measure
nb_enhanced_shared_artifacts                   | INT      | (Metric #10470) AEP Measure
nb_enhanced_specific_artifacts                 | INT      | (Metric #10471) AEP Measure
nb_evolved_transactions                        | INT      | (Metric #10460) AEP Measure
```

### APP_FUNCTIONAL_SIZING_MEASURES
Functional size measures by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
effort_complexity                    | DECIMAL  | (Metric #10350) Effort Complexity of transactions
equivalence_ratio                    | DECIMAL  | (Metric #10359) Equivalence ratio
nb_data_functions_points             | INT      | (Metric #10203) AFP measures
nb_total_points                      | INT      | (Metric #10202) AFP measures
nb_transactional_functions_points    | INT      | (Metric #10204) AFP measures
nb_transactions                      | INT      | (Metric #10461) Computed for AEP measures
```

### APP_HEALTH_EVOLUTION
Evolution of quality indicators by application snapshot, by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
previous_snapshot_id                 | TEXT     | The concatenation of the application name and the snapshot timestamp
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
nb_critical_violations_added         | INT      | (Metric #67901) Number of critical violations added
nb_critical_violations_removed       | INT      | (Metric #67902) Number of critical violations removed
nb_violations_added                  | INT      | (Metric #67921) Number of violations added
nb_violations_removed                | INT      | (Metric #67922) Number of violations removed
omg_technical_debt_added             | BIGINT   | (Metric #1062030) Added Remediation effort in minutes according to OMG Technical Debt
omg_technical_debt_deleted           | BIGINT   | (Metric #1062032) Deleted Remediation effort in minutes according to OMG Technical Debt
```

### APP_HEALTH_SCORES
Scores and number of violations by snapshot and by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
nb_critical_violations               | INT      | (Metric #67011) Business Criterion score
nb_violations                        | INT      | (Metric #67211) Business Criterion score
omg_technical_debt                   | BIGINT   | (Metric #1062020) Remediation effort in minutes according to OMG Technical Debt
score                                | DECIMAL  | Business Criterion grade (between 1.0 and 4.0)
compliance_score                     | DECIMAL  | Business Criterion compliance score (between 0.0 and 1.0)
```

### APP_SCORES
Quality Indicator scores by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
metric_id                            | INT      | AIP Globally unique metric ID
metric_name                          | TEXT     | Quality Indicator name
metric_type                          | TEXT     | Quality Indicator type: business-criterion, technical-criterion, quality-rule, quality-distribution, quality-distribution-category, quality-measure
score                                | DECIMAL  | Quality Indicator grade (between 1.0 and 4.0)
compliance_score                     | DECIMAL  | Quality Indicator compliance score (between 0.0 and 1.0)
```

### APP_SIZING_EVOLUTION
Evolution of sizes by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
previous_snapshot_id                 | TEXT     | The concatenation of the application name and the snapshot timestamp
nb_critical_violations_added         | INT      | (Metric #67901) Total number of critical violations added
nb_critical_violations_removed       | INT      | (Metric #67902) Total number of critical violations removed
nb_violations_added                  | INT      | (Metric #67921) Total number of violations added
nb_violations_removed                | INT      | (Metric #67922) Total number of violations removed
technical_debt_added                 | DECIMAL  | (Metric #68901) Technical debt of added violations
technical_debt_deleted               | DECIMAL  | (Metric #68902) Technical debt of removed violations
```

### APP_SIZING_MEASURES
Sizes by application snapshot.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
nb_artifacts                         | INT      | (Metric #10152) Total number of artifacts
nb_code_lines                        | INT      | (Metric #10151) Total number of code lines
nb_comment_lines                     | INT      | (Metric #10107) Total number of comment lines
nb_commented_out_code_lines          | INT      | (Metric #10109) Total number of code comment lines
nb_complexity_very_high              | INT      | (Metric #67002) Total number of artifacts with a very high cost complexity
nb_complexity_high                   | INT      | (Metric #67003) Total number of artifacts with a high cost complexity
nb_complexity_medium                 | INT      | (Metric #67004) Total number of artifacts with a medium cost complexity
nb_complexity_low                    | INT      | (Metric #67005) Total number of artifacts with a low cost complexity
nb_cyclomatic_very_high              | INT      | (Metric #65505) Total number of artifacts with a very high cyclomatic complexity
nb_cyclomatic_high                   | INT      | (Metric #65504) Total number of artifacts with a high cyclomatic complexity
nb_cyclomatic_medium                 | INT      | (Metric #65503) Total number of artifacts with a medium cyclomatic complexity
nb_cyclomatic_low                    | INT      | (Metric #65502) Total number of artifacts with a low cyclomatic complexity
nb_critical_violations               | INT      | (Metric #67011) Total number of critical violations
nb_decision_points                   | INT      | (Metric #10506) Total number of decision points
nb_files                             | INT      | (Metric #10154) Total number of files
nb_tables                            | INT      | (Metric #10163) Total number of tables
nb_violations                        | INT      | (Metric #67211) Total number of violations
nb_violations_excluded               | INT      | (Metric #67218) Total number of excluded violations
nb_violations_fixed_action_plan      | INT      | (Metric #67217) Total number of fixed violations for action plan
nb_violations_pending_action_plan    | INT      | (Metric #67216) Total number of pending violations in action plan
technical_debt_density               | DECIMAL  | (Metric #68002) Technical Debt density estimates the cost per thousand of lines of code to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
technical_debt_total                 | DECIMAL  | (Metric #68001) Technical Debt estimates the cost to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
```

### APP_TECHNO_SCORES
Quality Indicator scores by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
technology                           | TEXT     | Source code technology
metric_id                            | INT      | AIP Globally unique metric ID
metric_name                          | TEXT     | Quality Indicator name
metric_type                          | TEXT     | Quality Indicator type: business-criterion, technical-criterion, quality-rule, quality-distribution, quality-distribution-category, quality-measure
score                                | DECIMAL  | Quality Indicator grade (between 1.0 and 4.0)
compliance_score                     | DECIMAL  | Quality Indicator compliance score (between 0.0 and 1.0)
```

### APP_TECHNO_SIZING_EVOLUTION
Evolution of sizes by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
previous_snapshot_id                 | TEXT     | The concatenation of the application name and the snapshot timestamp
technology                           | TEXT     | Technology
nb_critical_violations_added         | INT      | (Metric #67901) Total number of critical violations added
nb_critical_violations_removed       | INT      | (Metric #67902) Total number of critical violations removed
nb_violations_added                  | INT      | (Metric #67921) Total number of violations added
nb_violations_removed                | INT      | (Metric #67922) Total number of violations removed
technical_debt_added                 | DECIMAL  | (Metric #68901) Technical debt of added violations
technical_debt_deleted               | DECIMAL  | (Metric #68902) Technical debt of removed violations
```

### APP_TECHNO_SIZING_MEASURES
Sizes by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
technology                           | TEXT     | Technology
nb_artifacts                         | INT      | (Metric #10152) Total number of artifacts
nb_code_lines                        | INT      | (Metric #10151) Total number of code lines
nb_comment_lines                     | INT      | (Metric #10107) Total number of comment lines
nb_commented_out_code_lines          | INT      | (Metric #10109) Total number of code comment lines
nb_complexity_very_high              | INT      | (Metric #67002) Total number of artifacts with a very high cost complexity
nb_complexity_high                   | INT      | (Metric #67003) Total number of artifacts with a high cost complexity
nb_complexity_medium                 | INT      | (Metric #67004) Total number of artifacts with a medium cost complexity
nb_complexity_low                    | INT      | (Metric #67005) Total number of artifacts with a low cost complexity
nb_cyclomatic_very_high              | INT      | (Metric #65505) Total number of artifacts with a very high cyclomatic complexity
nb_cyclomatic_high                   | INT      | (Metric #65504) Total number of artifacts with a high cyclomatic complexity
nb_cyclomatic_medium                 | INT      | (Metric #65503) Total number of artifacts with a medium cyclomatic complexity
nb_cyclomatic_low                    | INT      | (Metric #65502) Total number of artifacts with a low cyclomatic complexity
nb_critical_violations               | INT      | (Metric #67011) Total number of critical violations
nb_decision_points                   | INT      | (Metric #10506) Total number of decision points
nb_files                             | INT      | (Metric #10154) Total number of files
nb_tables                            | INT      | (Metric #10163) Total number of tables
nb_violations                        | INT      | (Metric #67211) Total number of violations
nb_violations_excluded               | INT      | (Metric #67218) Total number of excluded violations
nb_violations_fixed_action_plan      | INT      | (Metric #67217) Total number of fixed violations for action plan
nb_violations_pending_action_plan    | INT      | (Metric #67216) Total number of pending violations in action plan
technical_debt_density               | DECIMAL  | (Metric #68002) Technical Debt density estimates the cost per thousand of lines of code to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
technical_debt_total                 | DECIMAL  | (Metric #68001) Technical Debt estimates the cost to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
```

### APP_VIOLATIONS_EVOLUTION
Added and removed violation numbers by application snapshot, by technology, by rule. We extract measures for rules that are still active in the latest snapshot of each application. If for some reasons a rule has been deactivated or detached for an application, no measure are extracted for this application. Some rules may be not reported if both nb_added_violations and nb_removed_violations equal zero.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
previous_snapshot_id                 | TEXT     | The concatenation of the application name and the snapshot timestamp
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
metric_id                            | INT      | AIP Globally unique metric ID
technology                           | TEXT     | Source code technology
nb_violations_added                  | INT      | Number of added violations
nb_violations_removed                | INT      | Number of removed violations
```

### APP_VIOLATIONS_MEASURES
Violation ratio by application snapshot, by technology, by rule. We extract measures for rules that are still active in the latest snapshot of each application. If for some reasons a rule has been deactivated or detached for an application, no measure are extracted for this application.

```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
metric_id                            | INT      | AIP Globally unique metric ID
technology                           | TEXT     | Source code technology
nb_violations                        | INT      | Number of violations
nb_total_checks                      | INT      | Number of total checked objects
violation_ratio                      | DECIMAL  | The value of number of violations divided by the number of checked objects
compliance_ratio                     | DECIMAL  | The value of 1 - Violation Ratio
```

### DIM_APPLICATIONS
A Dimension table to filter measures according to Application Tags. The COLUMN names depend on the end-user categories.
We give an example here based on the demo site:
```
COLUMN                        | TYPE     | DESCRIPTION
------------------------------+----------+------------
application_name              | TEXT     | Table primary key
"Age"                         | TEXT     | A range of ages of the application
"Business Unit"               | TEXT     | The Business Unit as a sponsor or provider of the application
"Country"                     | TEXT     | The deployment country of the application
"Release Frequency"           | TEXT     | The release frequency of the application
"Sourcing"                    | TEXT     | The out sourcing company
"Methodology"                 | TEXT     | The application development approach
```

Note: if you need these column names to be converted into lowercase identifiers with no space character, and with no double-quotes delimiters, then set the environment variable QUOTED_IDENTIFIER=OFF

### DIM_CISQ_RULES
A dimension table to filter measures according to rules contribution to CISQ index
* Each row is a rule definition from the Assessment Model of the latest snapshot according to the 'functional/capture date' of each application , when a score exists for this application snapshot.
* In case of a rule with multiple technical criteria contributions, we select the contribution with the highest impact on grades considering the critical attribute and the weight attribute.

```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
technical_criterion_name             | TEXT     | The Technical Criterion name of the highest contribution weight for this rule
is_critical                          | BOOLEAN  | true if at least there is one critical contribution to a technical criterion
weight                               | DECIMAL  | Highest weight contribution to the technical criteria
weight_cisq_maintainability          | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_cisq_efficiency               | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_cisq_reliability              | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_cisq_security                 | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_cisq_index                    | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
```

### DIM_OMG_RULES
A dimension table to filter measures according to rules contribution to ISO index
* Each row is a rule definition from the Assessment Model of the latest snapshot according to the 'functional/capture date' of each application , when a score exists for this application snapshot.
* In case of a rule with multiple technical criteria contributions, we select the contribution with the highest impact on grades considering the critical attribute and the weight attribute.

```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
technical_criterion_name             | TEXT     | The Technical Criterion name of the highest contribution weight for this rule
is_critical                          | BOOLEAN  | true if at least there is one critical contribution to a technical criterion
weight                               | DECIMAL  | Highest weight contribution to the technical criteria
weight_omg_maintainability           | DECIMAL  | Contribution weight of the ISO technical criterion. 0 if no contribution
weight_omg_efficiency                | DECIMAL  | Contribution weight of the ISO technical criterion. 0 if no contribution
weight_omg_reliability               | DECIMAL  | Contribution weight of the ISO technical criterion. 0 if no contribution
weight_omg_security                  | DECIMAL  | Contribution weight of the ISO technical criterion. 0 if no contribution
weight_omg_index                     | DECIMAL  | Contribution weight of the ISO technical criterion. 0 if no contribution
```

### DIM_QUALITY_STANDARDS
A Dimension view to filter measures according to Quality Standards. 
* in case of a data extraction from a central base, the Quality Standard extension version must be __20181030__ or higher; it is recommended to install the __20190923__ version or higher to get the ISO standards
* in case of a data extraction from a measurement base, the measurement base must be __8.3.5__ or higher 

This view can be customized in order to extend the columns, by editing the SQL script: ```views/DIM_QUALITY_STANDARDS.sql```
See the STD_DESCRIPTIONS and STD_RULES tables to get the available quality standard tags.
By default the following BOOLEAN columns are defined:
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
metric_id                            | INT      | AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
aip_top_priority                     | BOOLEAN  | Check whether this rule is a top priority rule according to AIP
cwe                                  | BOOLEAN  | Check whether this rule detects a CWE weakness
omg_ascqm                            | BOOLEAN  | Check whether this rule detects ISO weakness
owasp_2017                           | BOOLEAN  | Check whether this rule detects a top 10 OWASP 2017 vulnerability
```

### DIM_RULES
A dimension table to filter measures according to rules contribution.
* Each row is a rule definition from the Assessment Model of the latest snapshot according to the 'functional/capture date' of each application , when a score exists for this application snapshot.
* The list of Business Criteria is closed. no custom business criteria are taken into account.
* In case of a rule with multiple technical criteria contributions, we select the contribution with the highest impact on grades considering the critical attribute and the weight attribute.

```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
business_criterion_id                | INT      | The Business Criterion name of the highest contribution weight for this rule
business_criterion_name              | TEXT     | The Business Criterion ID of the highest contribution weight for this rule
technical_criterion_weight           | DECIMAL  | Highest weight contribution to the Business Criteria
technical_criterion_id               | INT      | The Technical Criterion ID of the highest contribution weight for this rule
technical_criterion_name             | TEXT     | The Technical Criterion name of the highest contribution weight for this rule
is_critical                          | BOOLEAN  | true if at least there is one critical contribution to a technical criterion
weight                               | DECIMAL  | Highest weight contribution to the Technical Criteria
weight_architectural_design          | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_changeability                 | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_documentation                 | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_efficiency                    | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_maintainability               | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_programming_practices         | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_robustness                    | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_security                      | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_total_quality_index           | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
weight_transferability               | DECIMAL  | Contribution weight of the technical criterion. 0 if no contribution
```

### DIM_SNAPSHOTS
A Dimension table to filter measures according to a period. 
* Column YEAR, YEAR_MONTH, YEAR_QUARTER, YEAR_WEEK are set only for the most recent snapshot of this period for this application; they are provided to filter snapshots for a specific period
* These columns make sense when applications are periodically analyzed. For instance, if each application is analyzed once a year, then we can use the column YEAR as a filter; if some applications are not analyzed every week; then the YEAR_WEEK filter must be used carefully.

```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
application_id                       | INT      | Local Application ID
application_name                     | TEXT     | Application name
date                                 | DATE     | The snapshot capture date (ie the user input date) without timezone
analysis_date                        | DATE     | The snapshot analysis/processing date
snapshot_number                      | INT      | The snapshot sequence number
is_latest                            | BOOLEAN  | Check whether this is the latest snapshot of this application
year                                 | INT      | Tag the most recent application snapshot for each year (ex format: 2017-Q3)
year_quarter                         | TEXT     | Tag the most recent application snapshot for each quarter (ex format: 2017-Q3)
year_month                           | TEXT     | Tag the most recent application snapshot for each month (ex format: 2017-04)
year_week                            | TEXT     | Tag the most recent application snapshot for each week (ex format: 2017-W24)
label                                | TEXT     | Snapshot label
version                              | TEXT     | Application version
consolidation_mode                   | TEXT     | Consolidation mode when application score is based on modules scores; otherwise "Full Application"
internal_id                          | INT      | RESERVED - Do not use - Local Snapshot ID (use with cautious as this ID depends on the schema type: measurement/central). Use preferably snapshot_id column, or snapshot_number column. Do not use to order snapshots.
```

### MOD_HEALTH_EVOLUTION
Evolution of quality indicators by snapshot, by module and by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
previous_snapshot_id                 | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
nb_critical_violations_added         | INT      | (Metric #67901) Number of critical violations added
nb_critical_violations_removed       | INT      | (Metric #67902) Number of critical violations removed
nb_violations_added                  | INT      | (Metric #67921) Number of violations added
nb_violations_removed                | INT      | (Metric #67922) Number of violations removed
omg_technical_debt_added             | INT      | (Metric #1062030) Added Remediation effort in minutes according to OMG Technical Debt
omg_technical_debt_deleted           | INT      | (Metric #1062032) Deleted Remediation effort in minutes according to OMG Technical Debt
```

### MOD_HEALTH_SCORES
Scores and number of violations by snapshot, by module and by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
nb_critical_violations               | INT      | (Metric #67011) Business Criterion score
nb_violations                        | INT      | (Metric #67211) Business Criterion score
omg_technical_debt                   | INT      | (Metric #1062020) Remediation effort in minutes according to OMG Technical Debt
score                                | DECIMAL  | Business Criterion grade (between 1.0 and 4.0)
compliance_score                     | DECIMAL  | Business Criterion compliance score (between 0.0 and 1.0)
```

### MOD_SCORES
Quality Indicator scores by application snapshot and by module
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
metric_id                            | INT      | AIP Globally unique metric ID
metric_name                          | TEXT     | Quality Indicator name
metric_type                          | TEXT     | Quality Indicator type: business-criterion, technical-criterion, quality-rule, quality-distribution, quality-distribution-category, quality-measure
score                                | DECIMAL  | Quality Indicator grade (between 1.0 and 4.0)
compliance_score                     | DECIMAL  | Quality Indicator compliance score (between 0.0 and 1.0)
```

### MOD_SIZING_EVOLUTION
Evolution of sizes by snapshot and by module
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
previous_snapshot_id                 | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
nb_critical_violations_added         | INT      | (Metric #67901) Number of critical violations added
nb_critical_violations_removed       | INT      | (Metric #67902) Number of critical violations removed
nb_violations_added                  | INT      | (Metric #67921) Number of violations added
nb_violations_removed                | INT      | (Metric #67922) Number of violations removed
technical_debt_added                 | DECIMAL  | (Metric #68901) Technical debt of added violations
technical_debt_deleted               | DECIMAL  | (Metric #68902) Technical debt of removed violations
```

### MOD_SIZING_MEASURES
Technical sizes by snapshot, by module
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
nb_artifacts                         | INT      | (Metric #10152) Total number of artifacts
nb_code_lines                        | INT      | (Metric #10151) Total number of code lines
nb_comment_lines                     | INT      | (Metric #10107) Total number of comment lines
nb_commented_out_code_lines          | INT      | (Metric #10109) Total number of code comment lines
nb_complexity_very_high              | INT      | (Metric #67002) Total number of artifacts with a very high cost complexity
nb_complexity_high                   | INT      | (Metric #67003) Total number of artifacts with a high cost complexity
nb_complexity_medium                 | INT      | (Metric #67004) Total number of artifacts with a medium cost complexity
nb_complexity_low                    | INT      | (Metric #67005) Total number of artifacts with a low cost complexity
nb_cyclomatic_very_high              | INT      | (Metric #65505) Total number of artifacts with a very high cyclomatic complexity
nb_cyclomatic_high                   | INT      | (Metric #65504) Total number of artifacts with a high cyclomatic complexity
nb_cyclomatic_medium                 | INT      | (Metric #65503) Total number of artifacts with a medium cyclomatic complexity
nb_cyclomatic_low                    | INT      | (Metric #65502) Total number of artifacts with a low cyclomatic complexity
nb_critical_violations               | INT      | (Metric #67011) Total number of critical violations
nb_decision_points                   | INT      | (Metric #10506) Total number of decision points
nb_files                             | INT      | (Metric #10154) Total number of files
nb_tables                            | INT      | (Metric #10163) Total number of tables
nb_violations                        | INT      | (Metric #67211) Total number of violations
technical_debt_density               | DECIMAL  | (Metric #68002) Technical Debt density estimates the cost per thousand of lines of code to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
technical_debt_total                 | DECIMAL  | (Metric #68001) Technical Debt estimates the cost to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
```

### MOD_TECHNO_SCORES
Quality Indicator scores by application snapshot and by module
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
technology                           | TEXT     | Source code technology
metric_id                            | INT      | AIP Globally unique metric ID
metric_name                          | TEXT     | Quality Indicator name
metric_type                          | TEXT     | Quality Indicator type: business-criterion, technical-criterion, quality-rule, quality-distribution, quality-distribution-category, quality-measure
score                                | DECIMAL  | Quality Indicator grade (between 1.0 and 4.0)
compliance_score                     | DECIMAL  | Quality Indicator compliance score (between 0.0 and 1.0)
```

### MOD_TECHNO_SIZING_EVOLUTION
Evolution of sizes by snapshot and by module
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
previous_snapshot_id                 | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
technology                           | TEXT     | Technology
nb_critical_violations_added         | INT      | (Metric #67901) Number of critical violations added
nb_critical_violations_removed       | INT      | (Metric #67902) Number of critical violations removed
nb_violations_added                  | INT      | (Metric #67921) Number of violations added
nb_violations_removed                | INT      | (Metric #67922) Number of violations removed
technical_debt_added                 | DECIMAL  | (Metric #68901) Technical debt of added violations
technical_debt_deleted               | DECIMAL  | (Metric #68902) Technical debt of removed violations
```

### MOD_TECHNO_SIZING_MEASURES
Technical sizes by snapshot, by module
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
technology                           | TEXT     | Technology
module_name                          | TEXT     | Module name
nb_artifacts                         | INT      | (Metric #10152) Total number of artifacts
nb_code_lines                        | INT      | (Metric #10151) Total number of code lines
nb_comment_lines                     | INT      | (Metric #10107) Total number of comment lines
nb_commented_out_code_lines          | INT      | (Metric #10109) Total number of code comment lines
nb_complexity_very_high              | INT      | (Metric #67002) Total number of artifacts with a very high cost complexity
nb_complexity_high                   | INT      | (Metric #67003) Total number of artifacts with a high cost complexity
nb_complexity_medium                 | INT      | (Metric #67004) Total number of artifacts with a medium cost complexity
nb_complexity_low                    | INT      | (Metric #67005) Total number of artifacts with a low cost complexity
nb_cyclomatic_very_high              | INT      | (Metric #65505) Total number of artifacts with a very high cyclomatic complexity
nb_cyclomatic_high                   | INT      | (Metric #65504) Total number of artifacts with a high cyclomatic complexity
nb_cyclomatic_medium                 | INT      | (Metric #65503) Total number of artifacts with a medium cyclomatic complexity
nb_cyclomatic_low                    | INT      | (Metric #65502) Total number of artifacts with a low cyclomatic complexity
nb_critical_violations               | INT      | (Metric #67011) Total number of critical violations
nb_decision_points                   | INT      | (Metric #10506) Total number of decision points
nb_files                             | INT      | (Metric #10154) Total number of files
nb_tables                            | INT      | (Metric #10163) Total number of tables
nb_violations                        | INT      | (Metric #67211) Total number of violations
technical_debt_density               | DECIMAL  | (Metric #68002) Technical Debt density estimates the cost per thousand of lines of code to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
technical_debt_total                 | DECIMAL  | (Metric #68001) Technical Debt estimates the cost to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
```

### MOD_VIOLATIONS_EVOLUTION
Added and removed violation numbers by snapshot, by module, by technology, by rule. We extract measures for rules that are still active in the latest snapshot of each application. If for some reasons a rule has been deactivated or detached for an application, no measure are extracted for this application. Some rules may be not reported if both nb_added_violations and nb_removed_violations equal zero.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
previous_snapshot_id                 | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
metric_id                            | INT      | AIP Globally unique metric ID
technology                           | TEXT     | Source code technology
nb_violations_added                  | INT      | Number of added violations
nb_violations_removed                | INT      | Number of removed violations
```

### MOD_VIOLATIONS_MEASURES
Violation ratio by snapshot, by module and by technology, by rule. We extract measures for rules that are still active in the latest snapshot of each application. If for some reasons a rule has been deactivated or detached for an application, no measure are extracted for this application.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
rule_id                              | TEXT     | Local rule ID is the concatenation of local snapshot ID and the external rule ID
metric_id                            | INT      | AIP Globally unique metric ID
technology                           | TEXT     | Source code technology
nb_violations                        | INT      | Number of violations
nb_total_checks                      | INT      | Number of checked objects
violation_ratio                      | DECIMAL  | The value of number of violations divided by the number of checked objects
compliance_ratio                     | DECIMAL  | The value of 1 - Violation Ratio
```

### SRC_HEALTH_IMPACTS
Propagated Risk Index, and Risk Propagation Factor by Business Criterion and Source Object for the latest snapshot of each application
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
object_id                            | INT      | Concatenation of application name and object internal unique ID from central Base
object_name                          | TEXT     | Object name
business_criterion_name              | TEXT     | A business criterion
nb_violated_rules                    | INT      | Number of violated rules impacting the business criterion
nb_violations                        | INT      | Number of violations impacting the business criterion
propagated_risk_index                | DECIMAL  | Propagated Risk Index (PRI) is a measurement of a risk for an object and a business criterion
risk_propagation_factor              | DECIMAL  | The number of different call paths to reach the critical violations
```

### SRC_MOD_OBJECTS
Source objects of applications by module
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
application_name                     | TEXT     | Application name
module_name                          | TEXT     | Module name
object_id                            | INT      | Concatenation of application name and object internal unique ID from central Base
```

### SRC_OBJECTS
Source objects details
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
application_name                     | TEXT     | Application name
object_id                            | INT      | Concatenation of application name and object internal unique ID from central Base
object_name                          | TEXT     | Object name
object_full_name                     | TEXT     | Object location
technology                           | TEXT     | Associated Technology: JEE, .NET, etc.
object_status                        | TEXT     | Object status regarding the latest snapshot: added, updated, unchanged
action_planned                       | BOOLEAN  | An action has been planned for this object, see USR_ACTION_PLAN for more details
is_artifact                          | BOOLEAN  | A source object on which a cost complexity can be calculated
cost_complexity                      | INT      | This value is valid if IS_ARTIFACT if column is true
                                     |          | Cost complexity (-1: n/a, 0:low, 1:medium, 2:high, 3:very-high) is a risk assessment calculated from risk assessments of
                                     |          | - Cyclomatic complexity
                                     |          | - SQL cyclomatic complexity
                                     |          | - Granularity
                                     |          | - Lack of comments
```

### SRC_TRANSACTIONS
Transactions details. A transaction is a clone of the entry point source object
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
application_name                     | TEXT     | Application name
trx_id                               | INT      | Concatenation of application name and object internal unique ID from central Base
trx_name                             | TEXT     | Transaction name
trx_full_name                        | TEXT     | Transaction full name
trx_status                           | TEXT     | Transaction status regarding the latest snapshot: added, updated, unchanged. The status is 'updated' when a source object member has been updated
```

### SRC_TRX_HEALTH_IMPACTS
Transaction Risk Indexes for the 2 latest snapshots
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
trx_id                               | TEXT     | Concatenation of application name and object internal unique ID from central Base.
application_name                     | INT      | Application name
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
trx_name                             | TEXT     | Transaction name
security_risk_index                  | INT      | Transaction Risk Index (TRI) for Security health factor
efficiency_risk_index                | INT      | Transaction Risk Index (TRI) for Efficiency health factor
robustness_risk_index                | INT      | Transaction Risk Index (TRI) for Robustness health factor
```

### SRC_TRX_OBJECTS
Source objects of transactions
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
trx_id                               | INT      | The transaction ID from the SRC_TRANSACTIONS table
object_id                            | INT      | The source object ID, member of the transaction from the SRC_OBJECTS table
```

### SRC_VIOLATIONS
Violations for the 2 latest snapshots of each application of a central base
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
object_id                            | INT      | A source code component
finding_name                         | TEXT     | Also known as the "Associated Value Name"
finding_type                         | TEXT     | Type of finding among ["number", "percentage", "text", "object", "date", "integer", "no-value", "path", "group", "bookmark"]
nb_findings                          | INT      | Number of findings associated to this violation ; for example the number of bookmarks, number of paths, number of objects
```

### STD_DESCRIPTIONS
Descriptions of Quality Standards references
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
standard                             | TEXT     | Standard name (it may include a version number)
category                             | TEXT     | A category of the standard or a standard version name
tag                                  | TEXT     | Quality Standard reference (aka tag)
title                                | TEXT     | Title or short description of the reference
```

### STD_RULES
Mapping of Rules with Quality Standards references
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
metric_id                            | INT      | AIP Globally unique metric ID
tag                                  | TEXT     | Quality Standard reference (aka tag)
```

### USR_ACTION_PLAN
Users Requests to remediate violations. Note that a violation can be solved and raised again. Deactivated rules are not reported.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
application_name                     | TEXT     | Application name
rule_id                              | TEXT     | Key. Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
metric_id                            | TEXT     | AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
object_id                            | INT      | Concatenation of application name and object internal unique ID from central Base
object_name                          | TEXT     | Object name
object_full_name                     | TEXT     | Object full name
action_status                        | TEXT     | Status regarding the latest snapshot: added, pending, solved (ie fixed)
last_update_date                     | DATE     | Date of last edition update
start_date                           | DATE     | The creation date of the action plan issue
end_date                             | DATE     | The deactivation date of the action plan issue
user_name                            | TEXT     | The author of the action plan issue
comment                              | TEXT     | Additional text
priority                             | TEXT     | Priority
tag                                  | TEXT     | A tag to filter issues
```

### USR_EXCLUSIONS
Users Requests to discard some violations identified as false positive, for next snapshots
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
application_name                     | TEXT     | Application name
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
metric_id                            | TEXT     | AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
object_id                            | INT      | Concatenation of application name and object internal unique ID from central Base
object_name                          | TEXT     | Object name
object_full_name                     | TEXT     | Object full name
user_name                            | TEXT     | The author of the exclusion request
comment                              | TEXT     | Comment describing the reason of the exclusion
last_update_date                     | DATE     | Date of last edition update
exclusion_date                       | DATE     | Date of exclusion creation (date of most recent violations), violations are excluded after this date
exclusion_snapshot_id                | TEXT     | Reference of the snapshot at exclusion date, violations are excluded after this snapshot
```

