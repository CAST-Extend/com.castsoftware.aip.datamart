## Contents

- [Purpose](#purpose)
- [Limitations](#limitations)
- [How to Build the AIP Datamart](#how-to-build-the-aip-datamart)
- [How to Use the AIP Datamart ](#how-to-use-the-aip-datamart)
- [Summary of Tables](#summary-of-tables)
- [Data Dictionary](#data-dictionary)
- [Examples of Basic Queries](#examples-of-basic-queries)
- [Examples of Advanced Queries](#examples-of-advanced-queries) 

## Purpose
The AIP datamart is a simple database schema of AIP results, so that anyone can query these data, requiring only conceptual knowledge of AIP.

The AIP Datamart can be used:
* to query AIP data from a Business Intelligence tool such as Power BI Desktop
* to query AIP data using SQL  queries
* to create CSV report using SQL queries and the CSV export capability of postgreSQL

The use cases are:
* consume AIP data using a third party tool
* create specific reports
* check analysis results
* create dashboard to follow scores, measures and evolutions

## Limitations
* The scope of data is the measurement base results (however you can extract from a measurement base or a central base)
* The effective extracted data depend on the user's authorizations running the REST API from the extraction scripts. 
If the user is not granted to access to all applications, then some data will be skipped.
If the user is granted to access all applications, then, the user will expose all data in the target database.
* All data relative to Quality Distributions are skipped. 
* All data relative to Quality Measures are skipped.
* The list of Business Criteria is closed. Custom business criteria are skipped.

## How to Build the AIP Datamart

### The Scripts

The Datamart scripts are based on an ETL (Extract-Transform-Load) approach:
* __Extraction__ is using the REST API to export data as CSV content to allow easy data processing (there are dedicated Web Services to extract data; these services extract data using a stream to avoid memory consumption on Web Server).
* __Transform__ consists in Python scripts transforming CSV content into target SQL statements. 
* __Load__ consists in running  these SQL statements. 

The URIs of the REST API follow the tables names (replace the underscore character with a dash character):
<br>
Example to extract the DIM_APPLICATIONS content:
```
curl --no-buffer -f -k -H "Accept: text/csv"  -u %CREDENTIALS% "%ROOT%/datamart/dim-applications" -o "%EXTRACT_FOLDER%\%~2.csv" || EXIT /b 1
```
### Prerequisites

The prerequisites are:
* Windows operating system (scripts are *.BAT files)
* a remote access to the REST API server (__1.12__ or higher)
* a local access to a PostgreSQL server, with a database to host target data
* __[Python 3](https://www.python.org/downloads/)__ language
* the __[curl](https://curl.haxx.se/download.html)__ command line

### Running the Scripts
* Edit the scripts ```setenv.bat``` to configure the REST API and the Local PostgreSQL database accesses.
* Then start ```run.bat```.
* In case of errors, you will find a message on the standard output and some additional messages in the ```ETL.log``` file.

## How to Use the AIP Datamart

### CSV Reports

By querying the AIP Datamart tables, you can use the COPY SQL Statement of PostgreSQL to create a CSV output file (this file can be opened with Excel):
```
copy (select ...) to 'c:/temp/output.csv' WITH (format CSV);
```

Note that the output file is on the PostgreSQL server file system. If you do not have access to this file system, you can use stdout in place of a file name:
```
copy (select ...) to stdout WITH (format CSV);
```

### Power BI Desktop

If you intend to view the data with Power BI Desktop:
* Install the Power BI Desktop tool from [Microsoft marketplace](https://powerbi.microsoft.com/en-us/downloads/)
* Download the [PostgreSQL plugin](https://github.com/npgsql/Npgsql/releases)
* Install npgsql as Administrator (since the DLL would be pushed to GAC). During the installation stage, enabled "Npgsql GAC Installation"
* Restart the PC, then launch Power BI Desktop
* Import AIP Datamart tables using PostgreSQL plugin

## Summary of Tables

### Dimension Tables

These tables can be used to filter data along "Dimension":
* `DIM_RULES`: A Dimension table to filter measures according to rules contribution

* `DIM_QUALITY_STANDARDS`: A Dimension table to filter measures according to Quality Standards

* `DIM_SNAPSHOTS`: A Dimension table to filter measures according to a period

* `DIM_APPLICATIONS`: A Dimension table to filter measures according to Application Tags (Measurement base), and technologies

### Measures Tables

Application Measures of tables can be safely aggregated (average, sum) with a BI tool.
<br/>
__WARNING__: You cannot aggregate measures for a set of modules because of modules overlapping. However, you can aggregate measures for a specific module name.

Scope|Split by technology|Applications Table|Modules Table
-----|-----|------------|-------
Violations|Yes|`APP_VIOLATIONS_MEASURES`|`MOD_VIOLATIONS_MEASURES`
Technical Sizing|Yes|`APP_TECHNICAL_SIZING_MEASURES`|`MOD_TECHNICAL_SIZING_MEASURES`
Health Measures|No|`APP_HEALTH_MEASURES`|`MOD_HEALTH_MEASURES`
Technical Debt Measures|No|`APP_TECHNICAL_DEBT_MEASURES`|`MOD_TECHNICAL_DEBT_MEASURES`
Functional Sizing Measures|No|`APP_FUNCTIONAL_SIZING_MEASURES`|N/A

### Evolution Tables

Scope|Split by technology|Applications Table|Modules Table
-----|-----|------------|-------
Health Evolution|No|`APP_HEALTH_EVOLUTION`|`MOD_HEALTH_EVOLUTION`
Technical Debt Evolution|No|`APP_TECHNICAL_DEBT_EVOLUTION`|`MOD_TECHNICAL_DEBT_EVOLUTION`
Functional Sizing Evolution|No|`APP_FUNCTIONAL_SIZING_EVOLUTION`|N/A

## Data Dictionary

### DIM_APPLICATIONS
A Dimension table to filter measures according to Application Tags, and technologies.  The COLUMN names depend on the end-user tags and categories. We give an example here based on the demo site:

```
COLUMN                        | TYPE     | DESCRIPTION
------------------------------+----------+-----------
application_name"             | INT      | Table primary key
"Category  Age"               | TEXT     | A range of ages of the application
"Category  Business Unit"     | TEXT     | The Business Unit as a sponsor or provider of the application
"Category  Country"           | TEXT     | The deployment country of the application
"Category  Release Frequency" |TEXT      | The release frequency of the application
"Category  Sourcing"          | TEXT     | The out sourcing company
"Category Methodology"        | TEXT     | The application development approach
"Technology C++"              | BOOLEAN  | Check whether the application contains C++ code
"Technology JEE"              | BOOLEAN  | Check whether the application contains JEE code
```

### DIM_QUALITY_STANDARDS
A Dimension table to filter measures according to Quality Standards. 
* in case of a data extraction from a central base, the Quality Standard extension version must be __20181030__ or higher; it is recommended to install the __20190923__ version or higher to get the OMG standards
* in case of a data extraction from a measurement base, the measurement base must be __8.3.5__ or higher 

```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
metric_id                            | INT      | AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
aip_top_priority_rule                | BOOLEAN  | Check whether this rule is a top priority rule according  to AIP
cwe                                  | BOOLEAN  | Check whether this rule detects a CWE weakness
omg                                  | BOOLEAN  | Check whether this rule detects OMG/CISQ 2019 weakness
omg_maintainability                  | BOOLEAN  | Check whether this rule detects OMG/CISQ 2019 weakness
omg_performance_efficiency           | BOOLEAN  | Check whether this rule detects OMG/CISQ 2019 weakness
omg_reliability                      | BOOLEAN  | Check whether this rule detects OMG/CISQ 2019 weakness
omg_security                         | BOOLEAN  | Check whether this rule detects OMG/CISQ 2019 weakness
owasp_2017_top10                     | BOOLEAN  | Check whether this rule detects a top 10 OWASP 2017 vulnerability
owasp_mobile_2016_top10              | BOOLEAN  | Check whether this rule detects a top 10 OWASP 2016 vulnerability for Mobile code
```
### DIM_SNAPSHOTS
A Dimension table to filter measures according to a period. 
* Column YEAR, YEAR_MONTH, YEAR_QUARTER, YEAR_WEEK are set only for the most recent snapshot of this period for this application; they are provided to filter snapshots for a specific period
* These columns make sense when applications are periodically analyzed. For instance, if each application is analyzed once a year, then  we can use the column YEAR as a filter; if some applications are not analyzed every week; then the YEAR_WEEK filter must be used carefully. 
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
application_name                     | TEXT     | Application name
date                                 | DATE     | The snapshot capture date without timezone
is_latest                            | BOOLEAN  | Check whether this is the latest snapshot of this application
year                                 | INT      | Tag the most recent application snapshot for each year (ex format: 2017-Q3)
year_quarter                         | TEXT     | Tag the most recent application snapshot for each quarter (ex format: 2017-Q3)
year_month                           | TEXT     | Tag the most recent application snapshot for each month  (ex format: 2017-04)
year_week                            | TEXT     | Tag the most recent application snapshot for each week  (ex format: 2017-W24)
consolidation_settings               | TEXT     | The application score consolidation mode: 'Full Application', 'Average of Modules'
label                                | TEXT     | Snapshot label
```
### DIM_RULES
A dimension table to filter measures according to rules contribution.
* Each row is a rule definition from the Assessment Model of the latest snapshot according to the 'functional/capture date' of each application , when a result exist for this application snapshot.
* The list of Business Criteria is closed. no custom business criteria are taken into account.
* In case of a rule with multiple technical criteria contributions, we select the contribution with the highest impact on grades considering the critical attribute and the weight attribute.

```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
technical_criterion_name             | TEXT     | The Technical Criterion name of the highest contribution weight for this rule
is_critical                          | BOOLEAN  | true if at least there is one critical contribution to a technical criterion
weight                               | DOUBLE   | Highest weight contribution to the technical criteria
weight_architectural_design          | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
weight_changeability                 | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
weight_documentation                 | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
weight_efficiency                    | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
weight_maintainability               | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
weight_programming_practices         | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
weight_robustness                    | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
weight_security                      | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
weight_total_quality_index           | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
weight_transferability               | DOUBLE   | Contribution weight of the technical criterion. 0 if no contribution
```
### APP_VIOLATIONS_MEASURES
Violation ratio by application snapshot, by technology, by rule. We extract measures for rules that are still active in the latest snapshot of each application. If for some reasons a rule has been deactivated or detached for an application, no measure are extracted for this application.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
metric_id                            | INT      | AIP Globally unique metric ID
technology                           | TEXT     | Source code technology
nb_violations                        | INT      | Number of violations
nb_total_checks                      | INT      | Number of total checked objects
violation_ratio                      | DOUBLE   | The value of number of violations divided by the number of checked objects
compliance_ratio                     | DOUBLE   | The value of 1 - Violation Ratio
```
### APP_TECHNICAL_SIZING_MEASURES
Technical sizes by application snapshot, by technology
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
technology                           | TEXT     | Source code technology
nb_artifacts                         | INT      | (Metric #10152) Applicable to any technology
nb_code_lines                        | INT      | (Metric #10151) Applicable to any technology
nb_comment_lines                     | INT      | (Metric #10107) Applicable to any technology
nb_commented_out_code_lines          | INT      | (Metric #10109) Applicable to any technology
nb_decision_points                   | INT      | (Metric #10506) Applicable to any technology. The number of decision points is the sum of all artifact's Cyclomatic Complexity
nb_files                             | INT      | (Metric #10154) Applicable to any technology (except SQL)
nb_tables                            | INT      | (Metric #10163) Applicable to SQL based technologies
```
### APP_TECHNICAL_DEBT_MEASURES
Techical debt measures by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
technical_debt_density               | DOUBLE   |  (Metric #68002) Technical Debt density estimates the cost per thousand of lines of code to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
technical_debt_total                 | DOUBLE   | (Metric #68001) Technical Debt estimates the cost to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
```
### APP_FUNCTIONAL_SIZING_MEASURES
Functional size measures by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
nb_data_functions_points             | INT      | (Metric #10203) AFP measures
nb_total_points                      | INT      | (Metric #10202) AFP measures
nb_transactional_functions_points    | INT      | (Metric #10204) AFP measures
nb_transactions                      | INT      | (Metric #10461) Computed for AEP measures
```
### APP_HEALTH_MEASURES
Measures by application snapshot, by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
nb_critical_violations               | INT      | (Metric #67011) Business Criterion score
nb_violations                        | INT      | (Metric #67211) Business Criterion score
score                                | DOUBLE   | Business Criterion score
```
### APP_TECHNICAL_DEBT_EVOLUTION
Evolution of Technical debt by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Snapshot ID from the source database
previous_snapshot_id                 | INT      | Previous local snapshot ID
technical_debt_added                 | DOUBLE   | (Metric #68901) Technical debt of added violations
technical_debt_deleted               | DOUBLE   | (Metric #68902) Technical debt of removed violations
```
### APP_FUNCTIONAL_SIZING_EVOLUTION
Automatic Enhancement Points by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Snapshot ID from the source database
previous_snapshot_id                 | INT      | Previous local snapshot ID
nb_aefp_data_function_points         | INT      | (Metric #10431) AEP Measure
nb_aefp_implementation_points        | INT      | (Metric #10360) AEP Measure
nb_aefp_total_points                 | INT      | (Metric #10430) AEP Measure
nb_aefp_transactional_function_points| INT      | (Metric #10432) AEP Measure
nb_aep_points_added_functions        | INT      | (Metric #10451) AEP Measure
nb_aep_points_modified_functions     | INT      | (Metric #10453) AEP Measure
nb_aep_points_removed_functions      | INT      | (Metric #10452) AEP Measure
nb_aep_total_points                  | INT      | (Metric #10450) AEP Measure
nb_aetp_implementation_points        | INT      | (Metric #10362) AEP Measure
nb_aetp_total_points                 | INT      | (Metric #10440) AEP Measure
```
### APP_HEALTH_EVOLUTION
Evolution of quality indicators by application snapshot, by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
previous_snapshot_id                 | INT      | Previous local snapshot ID
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
nb_critical_violations_added         | INT      | (Metric #67901) Number of critical violations added
nb_critical_violations_removed       | INT      | (Metric #67902) Number of critical violations removed
nb_violations_added                  | INT      | (Metric #67921) Number of violations added
nb_violations_removed                | INT      | (Metric #67922) Number of violations removed
```
### MOD_VIOLATIONS_MEASURES
Violation ratio by snapshot, by module and by technology, by rule. We extract measures for rules that are still active in the latest snapshot of each application. If for some reasons a rule has been deactivated or detached for an application, no measure are extracted for this application.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
module_name                          | TEXT     | Module name
rule_id                              | TEXT     | Local rule ID is the concatenation of local snapshot ID and the external rule ID
metric_id                            | INT      | AIP Globally unique metric ID
technology                           | TEXT     | Source code technology
nb_violations                        | INT      | Number of violations
nb_total_checks                      | INT      | Number of checked objects
violation_ratio                      | DOUBLE   | The value of number of violations divided by the number of checked objects
compliance_ratio                     | DOUBLE   | The value of 1 - Violation Ratio
```
### MOD_TECHNICAL_SIZING_MEASURES
Technical sizes by snapshot, by module and by technology
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Snapshot ID from the source database
module_name                          | TEXT     | Module name
technology                           | TEXT     | Source code technology
nb_artifacts                         | INT      | (Metric #10152) Applicable to any technology
nb_code_lines                        | INT      | (Metric #10151) Applicable to any technology
nb_comment_lines                     | INT      | (Metric #10107) Applicable to any technology
nb_commented_out_code_lines          | INT      | (Metric #10109) Applicable to any technology
nb_decision_points                   | INT      | (Metric #10506) Applicable to any technology. The number of decision points is the sum of all artifact's Cyclomatic Complexity
nb_files                             | INT      | (Metric #10154) Applicable to any technology (except SQL)
nb_tables                            | INT      | (Metric #10163) Applicable to SQL based technologies
```
### MOD_TECHNICAL_DEBT_MEASURES
Technical debt by snapshot and by module
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
module_name                          | TEXT     | Module name
technical_debt_density               | DOUBLE   | (Metric #68002) Technical Debt density estimates the cost per thousand of lines of code to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
technical_debt_total                 | DOUBLE   | (Metric #68001) Technical Debt estimates the cost to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
```
### MOD_HEALTH_MEASURES
Score and number of violations by snapshot, by module and by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
module_name                          | TEXT     | Module name
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
nb_critical_violations               | INT      | (Metric #67011) Business Criterion score
nb_violations                        | INT      | (Metric #67211) Business Criterion score
score                                | DOUBLE   | Business Criterion score
```
### MOD_TECHNICAL_DEBT_EVOLUTION
Evolution of Technical debt by snapshot and by module
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Snapshot ID from the source database
previous_snapshot_id                 | INT      | Previous local snapshot ID
module_name                          | TEXT     | Module name
technical_debt_added                 | DOUBLE   | (Metric #68901) Technical debt of added violations
technical_debt_deleted               | DOUBLE   | (Metric #68902) Technical debt of removed violations
```
### MOD_HEALTH_EVOLUTION
Evolution of quality indicators by snapshot, by module and by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+-----------
snapshot_id                          | INT      | Local Snapshot ID
previous_snapshot_id                 | INT      | Previous local snapshot ID
module_name                          | TEXT     | Module name
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
technology                           | TEXT     | Source code technology
nb_critical_violations_added         | INT      | (Metric #67901) Number of critical violations added
nb_critical_violations_removed       | INT      | (Metric #67902) Number of critical violations removed
nb_violations_added                  | INT      | (Metric #67921) Number of violations added
nb_violations_removed                | INT      | (Metric #67922) Number of violations removed
```
## Examples of Basic Queries

### Number of Critical Violations by Business Criterion

Query:
```
select sum(t.nb_critical_violations), t.business_criterion_name
from dim_snapshots s
join app_health_measures t on t.snapshot_id = s.snapshot_id 
where s.is_latest
group by 2
order by 1 desc
```
Data output:
```
1543|"Total Quality Index"
1282|"Programming Practices"
 879|"Security"
 864|"Robustness"
 389|"Efficiency"
 363|"Changeability"
  81|"Architectural Design"
  51|"Transferability"
   0|"Documentation"
```
### Top 5 Critical Rules

Query:
```
select r.rule_name, sum(nb_violations), sum(nb_total_checks)
from app_violations_measures m
join dim_snapshots s on m.snapshot_id = s.snapshot_id and s.is_latest
join dim_rules r on r.rule_id = m.rule_id and r.is_critical
group by 1
order by 2 desc limit 5
```

Data output:
```
"Avoid unchecked return code (SY-SUBRC) after OPEN SQL or READ statement"|347| 540
"Avoid declaring public Fields"                                          |122| 433
"Avoid empty catch blocks"                                               |101|9445
"Avoid using Fields (non static final) from other Classes"               | 93|4291
"Never truncate data in MOVE statements"                                 | 82|  90
```

### Total technical debt

Query:
```
select sum(technical_debt_total)
from app_technical_debt_measures m
join dim_snapshots s on m.snapshot_id = s.snapshot_id and s.is_latest
```

Data output:
```
2943542.25
```

### Total number of Code Lines

Query:
```
select sum(nb_code_lines)
from app_technical_sizing_measures m
join dim_snapshots s on m.snapshot_id = s.snapshot_id and s.is_latest
```

Data output:
```
338232
```

### Total number of violations of Top Priority Rules

Query:
```
select sum(m.nb_violations)
from app_violations_measures m
join dim_rules r on r.rule_id = m.rule_id
join dim_snapshots s on m.snapshot_id = s.snapshot_id and s.is_latest
join dim_quality_standards q on q.metric_id = m.metric_id and q.aip_top_priority_rule
```

Data output:
```
3
```

### Total number of Function Points

Query:
```
select sum(nb_total_points)
from app_functional_sizing_measures m
join dim_snapshots s on m.snapshot_id = s.snapshot_id and s.is_latest
```

Data output:
```
4445
```

### Average score of Total Quality Indexes

Query:
```
select avg(score)
from app_health_measures m
join dim_snapshots s on m.snapshot_id = s.snapshot_id and s.is_latest
where m.business_criterion_name = 'Total Quality Index'
```

Data output:
```
2.35780983144241
```

### Number of OWASP Top 10 2017 vulnerabilities by Rule

Query:
```
select m.metric_id, r.rule_name, m.technology, m.nb_violations
from app_violations_measures m
join dim_rules r on r.rule_id = m.rule_id
join dim_snapshots s on m.snapshot_id = s.snapshot_id and s.is_latest and s.application_name = 'Big Ben'
join dim_quality_standards q on q.metric_id = m.metric_id and q.owasp_2017_top10
where m.nb_violations <> 0 
order by nb_violations desc
```

Data output:
```
7906|"Avoid testing specific values for SY-UNAME"|"ABAP"|1
```


## Examples of Advanced Queries

### Ratio of Critical Violations per Function Point

Query:
```
select
(select sum(m.nb_violations) * 1.0 -- cast to double
from dim_snapshots s
join app_violations_measures m on m.snapshot_id = s.snapshot_id
join dim_rules r on r.rule_id = m.rule_id and r.is_critical
where s.is_latest and s.application_name = 'Big Ben') 
/
(select m.nb_total_points
from dim_snapshots s
join app_functional_sizing_measures m on m.snapshot_id = s.snapshot_id
where s.is_latest and s.application_name = 'Big Ben')
```

Data output:
```
0.13920194943649101432
```

### Delta of critical violations by rule between first Quarter of 2013 and last Quarter of 2013

Query:
```
select m1.metric_id, r.rule_name, m1.technology, m1.nb_violations - m2.nb_violations
from dim_rules r
join dim_snapshots s1 on s1.year_quarter = '2013-Q1' and s1.application_name = 'Big Ben'
join app_violations_measures m1 on m1.rule_id = r.rule_id and m1.snapshot_id = s1.snapshot_id 
join dim_snapshots s2 on s2.year_quarter = '2013-Q4' and s2.application_name = 'Big Ben'
join app_violations_measures m2 on m2.rule_id = r.rule_id and m2.snapshot_id = s2.snapshot_id and m2.technology = m1.technology
where r.is_critical
order by 4 desc
```

Data output:
```
5062|"Avoid using ALTER"                            |"Cobol"|  0
5094|"Avoid using MOVE CORRESPONDING ... TO ..."    |"Cobol"|  0
7218|"Avoid OPEN/CLOSE inside loops"                |"Cobol"|  0
7906|"Avoid testing specific values for SY-UNAME"   |"ABAP" | -1
7534|"Avoid READ TABLE without BINARY SEARCH"       |"ABAP" | -2
8106|"Avoid empty IF-ENDIF blocks"                  |"ABAP" |-19
7868|"Avoid Open SQL queries in loops"              |"ABAP" |-41
```

### Number of critical violations for the latest 4 quarters of 2013

Query:
```
select q1.v as q1, q2.v as q2, q3.v as q3, q4.v as q4
from 

( select sum(m.nb_violations) as v
  from dim_snapshots s 
  join app_violations_measures m on m.snapshot_id = s.snapshot_id
  join dim_rules r on r.rule_id = m.rule_id and r.is_critical
  where s.year_quarter = '2013-Q1' and s.application_name = 'Big Ben') q1,

( select sum(m.nb_violations) as v
  from dim_snapshots s 
  join app_violations_measures m on m.snapshot_id = s.snapshot_id
  join dim_rules r on r.rule_id = m.rule_id and r.is_critical
  where s.year_quarter = '2013-Q2' and s.application_name = 'Big Ben') q2,

( select sum(m.nb_violations) as v
  from dim_snapshots s 
  join app_violations_measures m on m.snapshot_id = s.snapshot_id
  join dim_rules r on r.rule_id = m.rule_id and r.is_critical
  where s.year_quarter = '2013-Q3' and s.application_name = 'Big Ben') q3,

( select sum(m.nb_violations) as v
  from dim_snapshots s 
  join app_violations_measures m on m.snapshot_id = s.snapshot_id
  join dim_rules r on r.rule_id = m.rule_id and r.is_critical
  where s.year_quarter = '2013-Q4' and s.application_name = 'Big Ben') q4
  ```

Data output:
```
107|124|NULL|457
```
