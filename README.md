See the [release notes](RELEASE_NOTES.md) for the compatible REST API versions.

## Contents

- [Purpose](#purpose)
- [Limitations](#limitations)
- [Terms and Conditions](#terms-and-conditions)
- [How to Build the AIP Datamart](#how-to-build-the-aip-datamart)
- [How to Use the AIP Datamart ](#how-to-use-the-aip-datamart)
- [Summary of Tables](#summary-of-tables)
- [Data Dictionary](#data-dictionary)
- [Measurement Queries: Basic Examples](#measurement-queries-basic-examples)
- [Measurement Queries: Advanced Examples](#measurement-queries-advanced-examples)
- [Findings Queries Examples](#findings-queries-examples)

## Purpose
The AIP datamart is an extraction of AIP results into a PostgreSQL schema, so that anyone can query these data, requiring only conceptual knowledge of AIP.

The AIP Datamart can be used:
* to query AIP data from a Business Intelligence tool such as Power BI Desktop
* to query AIP data using SQL  queries
* to create CSV report using SQL queries and the CSV export capability of PostgreSQL

The goals can be:
* to make reports for stakeholders
* to make trending reports on some Key Production Indicators
* to promote AIP data
* to search for "golden nuggets"
* to check an AIP analysis configuration

The use cases are:
* consume AIP data using a third party tool
* create specific reports
* check analysis results
* create dashboard to follow scores, measures and evolutions

## Limitations
* The effective extracted data depend on the user's authorizations running the REST API from the extraction scripts. 
If the user is not granted to access to all applications, then some data will be skipped.
If the user is granted to access all applications, then, the user will expose all data in the target database.
* For the DIM_RULES table, the list of Business Criteria is closed. Custom business criteria are skipped.

## Terms and Conditions

These scripts are submitted to terms and conditions of [GNU License](LICENSE)

By using this software, the user of this product agrees the terms and conditions of third party softwares: 
- [Curl Copyright License](https://curl.se/docs/copyright.html)
- [PostgreSQL License](https://www.postgresql.org/about/licence/)
- [Python License](https://docs.python.org/3/license.html)

A copy of these notices is available in the distributed package of this product.

## How to Build the AIP Datamart

### The Scripts

The scripts are *.BAT files for Windows operating systems.

The Datamart scripts are based on an ETL (Extract-Transform-Load) approach:
* __Extraction__ is using the REST API to export data as CSV content to allow easy data processing (there are dedicated Web Services to extract data; these services extract data using a stream to avoid memory consumption on Web Server).
* __Transform__ consists in Python scripts transforming CSV content into target SQL statements. 
* __Load__ consists in running  these SQL statements. 

The URIs of the REST API follow the tables names (replace the underscore character with a dash character):
<br>
Example to extract the DIM_APPLICATIONS content:
```
curl --no-buffer -f -k -H "Accept: text/csv"  -u %CREDENTIALS% "%ROOT%/AAD/datamart/dim-applications" -o "%EXTRACT_FOLDER%\%~2.csv" 
```

### Running the Scripts 

* __Make sure__ you have access to 
  * a REST API server for Dashboards (see version in the release notes)
  * a PostgreSQL server 9.1 or higher, with a database created to host target data
* __Download__ the Datamart scripts from [extend.castsoftware.com](https://extend.castsoftware.com/#/search-results?q=datamart) package
     * Unzip the archive, and move the content into a single target folder
     * Note: you do not need to install any software, all the required embedded softwares are available in the ```thirdparty``` directory
* __Edit configuration variables__ in ```setenv.bat``` file
  * PostgreSQL executables if you do not use the embedded third party binaries:
      * ```PSQL```: the absolute path to the psql command (see your PostgreSQL install directory)
      * ```VACUUMDB```: the absolute path to the vacummdb command (see your PostgreSQL install directory)
  * Target Database:
      * ```_DB_HOST```: the PostgreSQL server host name
      * ```_DB_PORT```: the PostgreSQL server port
      * ```_DB_NAME```: the target PostgreSQL database
      * ```_DB_USER```: the PostgreSQL user name 
      * ```_DB_SCHEMA```: the target schema name
* __Set PostgreSQL server password__ in ```PGPASSWORD``` environment variable
* __Set credentials__ to authenticate to the REST API in ```CREDENTIALS``` environment variable with the following format ```username:password``` or set the ```APIKEY``` environment variable
    
_Note_: If you set an environment variable with a special character such as ```&<>()!``` then you MUST NOT use double-quotes, but escape the characters with ```^``` character:
Example:
```
REM John is the user name and R2&D2! is the password
SET CREDENTIALS=John:R2^&D2^^!
```

You can avoid this kind of issue, using the obfuscation mechanism.

#### Password obfuscation

You can obfuscate the ```CREDENTIALS```, ```PGPASSWORD```, ```APIKEY``` environment variables as follow:

```
C:>python utilities\encode.py mysecret
HEX:773654446d734f6c773550446a4d4f6777347a4372673d3d

SET PGPASSWORD=HEX:773654446d734f6c773550446a4d4f6777347a4372673d3d
```
This obfuscation prevents the [shoulder surfing](https://en.wikipedia.org/wiki/Shoulder_surfing_%28computer_security%29). It does not prevent an operator to access the secret values in clear text.

#### Single Data Source

This mode allows to extract data of a single Health domain or a single Engineering domain into a target database.

* __Edit__ the scripts ```setenv.bat``` to set the default REST API URL and DOMAIN
  * ```DEFAULT_ROOT```: URL to a REST API, ex: ```http://localhost:9090/CAST-RESTAPI/rest```
  * ```DEFAULT_DOMAIN```: the REST API domain name, ex: ```AAD``` for the Health domain, or an Engineering domain
* __Start__ ```run.bat install``` 
* In case of errors, you will find a message on the standard output and some additional messages in the ```log``` directory.

After a first install, if you start ```run.bat refresh```, the script will just truncate the datamart tables before re-loading data, preserving custom tables and views that depends on datamart tables.

Start ```run.bat help``` for more information on these modes.

#### Multiple Data Sources

This mode allows to extract data from an Health domain (```AAD```), and all related Engineering domains into a single target database.

* __Edit__ the ```setenv.bat``` script to override the following environment variables:
  * ```HD_ROOT```: URL to the REST API hosting the ```AAD``` domain
  * ```ED_ROOT```: URL to the REST API hosting the engineering domains; this URL can be the same as the ```HD_ROOT```
  * ```JOBS```: the number of concurrent transfer processes. By default the number is 1 for a sequential mode.
* __Start__ ```datamart.bat install``` from a CMD window (do not double click from the explorer)
* In case of errors, you will find a message on the standard output and some additional messages in the ```log``` directory.

After a first install, if you start ```datamart.bat refresh```, the script will just truncate the datamart tables before re-loading data, preserving custom tables and views that depends on datamart tables.

If you start ```datamart.bat update```, the script will synchronize the datamart with new snapshots; saving extract and loading time.

#### Troubleshooting Guides

> I have got an "Access Denied" message.

Make sur you have write access on the Datamart folder.

> The Datamart scripts are stuck.

If the extraction step is never ending, then look at the Web Server (Tomcat) log to check whether there is a Java Memory error: "Ran out of memory".
- In case of a single data source extraction, you will have to increase the memory ot the Tomcat server.
- In case of a mutiple data source extraction, you can either increase the memory of the Tomcat setver or decrease the number of jobs (see ```JOBS``` variable).

You can check the total memory currently use by the Web Server with this call:
```
curl -u %CREDENTIALS% "%ROOT%/server"  
```
The response reports the initial memory size when Tomcat has been started, and the total memory size required until now:
```
{
	"href": "server",
	"name": "Server",
	"startDate": {
		"time": 1625148593901,
		"isoDate": "2021-07-01"
	},
	"memory": {
		"totalInitialMemory": 495,
		"totalMemory": 662,
```


## Schema Upgrade

If you have previously installed the Datamart tables, and have upgraded later the REST API, then the database schema may be not synchronized with some new columns that have been added. To fix that, you may need to run the ```upgrade_schema.bat``` script. For the first release of the Datamart the script is empty.

## How to Use the AIP Datamart

### Grant Access to Users

If it does not exist yet, you can create a role ```reports``` with a read only right granted, so that this account will not be allowed to change the measures.
For example if the target database name is ```reporting```, and target schema name is ```datamart```, you can create the role ```reports``` with the following rights:
```
CREATE ROLE reports WITH LOGIN ENCRYPTED PASSWORD '...';
GRANT CONNECT ON DATABASE reporting TO reports;
GRANT USAGE ON SCHEMA datamart TO reports;
GRANT SELECT ON ALL TABLES IN SCHEMA datamart TO reports;
```

### Custom Tables

In ```refresh``` mode, the scripts will truncate the Datamart tables. All other tables and views are left unchanged.

In ```install``` mode, the scripts will drop and recreate Datamart tables. However, you can add your own tables. Indeed, when you run the scripts it leaves these tables unchanged. Only the database views must be recreated.

### CSV Reports

By querying the AIP Datamart tables, you can use the COPY SQL Statement of PostgreSQL to create a CSV output file (this file can be opened with Excel):
```
copy (select ...) to 'c:/temp/output.csv' WITH (format CSV, header);
```

Note that the output file is on the PostgreSQL server file system. If you do not have access to this file system, you can use stdout in place of a file name:
```
copy (select ...) to stdout WITH (format CSV, header);
```

Example of a report of health factors scores that you can open with Excel:
```
copy (select s.application_name, s.date, max(m1.score) as efficiency, max(m2.score) as transferability, max(m3.score) as changeability, max(m4.score) as Robustness, max(m5.score) as security
from dim_snapshots s
left join app_scores m1 on m1.snapshot_id = s.snapshot_id and m1.metric_id = 60014
left join app_scores m2 on m2.snapshot_id = s.snapshot_id and m2.metric_id = 60011
left join app_scores m3 on m3.snapshot_id = s.snapshot_id and m3.metric_id = 60012
left join app_scores m4 on m4.snapshot_id = s.snapshot_id and m4.metric_id = 60013
left join app_scores m5 on m5.snapshot_id = s.snapshot_id and m5.metric_id = 60016
group by 1,2
order by 1, 2) to 'c:/temp/report.csv' with (format CSV, header);
```

### Power BI Desktop

If you intend to view the data with Power BI Desktop:
* Install the Power BI Desktop tool from [Microsoft marketplace](https://powerbi.microsoft.com/en-us/downloads/)
* Download the [PostgreSQL plugin](https://github.com/npgsql/Npgsql/releases)
* Install npgsql as Administrator (since the DLL would be pushed to GAC). During the installation stage, enabled "Npgsql GAC Installation"
* Restart the PC, then launch Power BI Desktop
* Import AIP Datamart tables using PostgreSQL plugin

### Datapond

This toolkit provides 2 Datapond compliant views:
* [views/BASEDATA_FLAT.sql](views/BASEDATA_FLAT.sql): this view transposes business criteria scores to columns, and provides new metrics using SQL expressions;
* [views/COMPLETE_FLAT.sql](views/COMPLETE_FLAT.sql): this view extends the BASEDATA_FLAT view with AEP measures, and adds AEP based metrics using the SQL average operator.

The differences with Datapond 5.1 corresponding views are as follow:
* Some columns are missing 
  * the `technologies` column has been removed
  * EFP columns have been removed; because these values are replaced with AEP metrics 
* For some data, the precision for decimal values may differ; because the Datapond applies some pre-rounding with Python scripts using the "rounding half to even" strategy, which is not the PostgreSQL rounding strategy
* When AEP has not be calculated for a snapshot, the Datamart reports the 'null' value, whereas the Datapond reports the value of the next snapshot
* The calculation of averages has been fixed

To add these 2 database views to the Datamart schema, runs `create_datapond_views.bat` file from your installation directory:
```
C:\>create_datapond_views
```

## Summary of Tables

### Dimension Tables

These tables can be used to filter data along "Dimension":
* `DIM_RULES`: A Dimension table to filter measures according to rules contribution

* `DIM_OMG_RULES`: A Dimension table to filter measures according to rules contribution to ISO index

* `DIM_CISQ_RULES`: A Dimension table to filter measures according to rules contribution to CISQ index
* `DIM_QUALITY_STANDARDS`: A Dimension view to filter measures according to Quality Standards

* `DIM_OMG_ASCQM`: An optional(*) Dimension view to filter measures according to the ISO standard criteria

* `DIM_OWASP_2017`: A optional(*) Dimension view to filter measures according to OWASP 2017 Top 10 vulnerabilities

* `DIM_SNAPSHOTS`: A Dimension table to filter measures according to a period

* `DIM_APPLICATIONS`: A Dimension table to filter measures according to Application Tags (Measurement base)

(*): Optional means that the view is not created by default. runs `create_views.bat` file from your installation directory.

### Measures Tables

Measures are results that can be aggregated with a BI tool. Metrics are set by column.
Application Measures of tables can be safely aggregated (average, sum) with a BI tool.
<br/>
__WARNING__: You cannot aggregate measures for a set of modules because of modules overlapping. However, you can aggregate measures for a specific module name.

Scope|Applications Table|Modules Table
-----|------------|-------
Violations <sup>(1)</sup>|`APP_VIOLATIONS_MEASURES`|`MOD_VIOLATIONS_MEASURES`
Sizing Measures|`APP_SIZING_MEASURES`|`MOD_SIZING_MEASURES`
Functional Sizing Measures|`APP_FUNCTIONAL_SIZING_MEASURES`|N/A

(1): Split by technology

### Scores Tables

Scope|Applications Table|Modules Table
-----|------------|-------
Health (Business Criteria) Scores|`APP_HEALTH_SCORES`|`MOD_HEALTH_SCORES`
All Scores|`APP_SCORES`|`MOD_SCORES`

### Evolution Tables

Scope|Applications Table|Modules Table
-----|------------|-------
Health Evolution|`APP_HEALTH_EVOLUTION`|`MOD_HEALTH_EVOLUTION`
Sizing Evolution|`APP_SIZING_EVOLUTION`|`MOD_SIZING_EVOLUTION`
Functional Sizing Evolution|`APP_FUNCTIONAL_SIZING_EVOLUTION`|N/A

### Details Tables (Central Database only)

Scope|Table
-----|------------
Source objects|`SRC_OBJECTS`
Source objects|`SRC_HEALTH_IMPACTS`
Source objects|`SRC_MOD_OBJECTS`
Source objects|`SRC_TRANSACTIONS`
Source objects|`SRC_TRX_OBJECTS`
Source objects|`SRC_TRX_HEALTH_IMPACTS`
Source objects|`SRC_VIOLATIONS`
Users requests|`USR_EXCLUSIONS`
Users requests|`USR_ACTION_PLAN`

### Other tables

Scope|Table
-----|------------
Quality Standards Mapping|`STD_RULES`
Quality Standards Mapping|`STD_DESCRIPTIONS`

## Data Dictionary

### DIM_APPLICATIONS
A Dimension table to filter measures according to Application Tags. The COLUMN names depend on the end-user categories. We give an example here based on the demo site:

```
COLUMN                        | TYPE     | DESCRIPTION
------------------------------+----------+-----------
application_name              | INT      | Table primary key
"Age"                         | TEXT     | A range of ages of the application
"Business Unit"               | TEXT     | The Business Unit as a sponsor or provider of the application
"Country"                     | TEXT     | The deployment country of the application
"Release Frequency"           | TEXT     | The release frequency of the application
"Sourcing"                    | TEXT     | The out sourcing company
"Methodology"                 | TEXT     | The application development approach
```

Note: if you need these column names to be converted into lowercase identifiers with no space character, and with no double-quotes delimiters, then set the environment variable QUOTED_IDENTIFIER=OFF

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
aip_top_priority                     | BOOLEAN  | Check whether this rule is a top priority rule according to AIP
cwe                                  | BOOLEAN  | Check whether this rule detects a CWE weakness
omg_ascqm                            | BOOLEAN  | Check whether this rule detects ISO weakness
owasp_2017                           | BOOLEAN  | Check whether this rule detects a top 10 OWASP 2017 vulnerability
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
year_month                           | TEXT     | Tag the most recent application snapshot for each month  (ex format: 2017-04)
year_week                            | TEXT     | Tag the most recent application snapshot for each week  (ex format: 2017-W24)
label                                | TEXT     | Snapshot label
version                              | TEXT     | Application version
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
technical_criterion_name             | TEXT     | The Technical Criterion name of the highest contribution weight for this rule
is_critical                          | BOOLEAN  | true if at least there is one critical contribution to a technical criterion
weight                               | DECIMAL  | Highest weight contribution to the technical criteria
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
### APP_VIOLATIONS_MEASURES
Violation ratio by application snapshot, by technology, by rule. We extract measures for rules that are still active in the latest snapshot of each application. If for some reasons a rule has been deactivated or detached for an application, no measure are extracted for this application.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
metric_id                            | INT      | AIP Globally unique metric ID
technology                           | TEXT     | Source code technology
nb_violations                        | INT      | Number of violations
nb_total_checks                      | INT      | Number of total checked objects
violation_ratio                      | DECIMAL  | The value of number of violations divided by the number of checked objects
compliance_ratio                     | DECIMAL  | The value of 1 - Violation Ratio
```
### APP_SIZING_MEASURES
Sizes by application snapshot
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
nb_artifacts                         | INT      | (Metric #10152) Total number of artifacts
nb_code_lines                        | INT      | (Metric #10151) Total number of code lines
nb_comment_lines                     | INT      | (Metric #10107) Total number of comment lines
nb_commented_out_code_lines          | INT      | (Metric #10109) Total number of code comment lines
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
### APP_HEALTH_SCORES
Score and number of violations by snapshot and by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
nb_critical_violations               | INT      | (Metric #67011) Business Criterion score
nb_violations                        | INT      | (Metric #67211) Business Criterion score
score                                | DECIMAL  | Business Criterion score
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
score                                | DECIMAL  | Quality Indicator grade
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
technology                           | TEXT     | Source code technology
nb_violations                        | INT      | Number of violations
nb_total_checks                      | INT      | Number of checked objects
violation_ratio                      | DECIMAL  | The value of number of violations divided by the number of checked objects
compliance_ratio                     | DECIMAL  | The value of 1 - Violation Ratio
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
nb_critical_violations               | INT      | (Metric #67011) Total number of critical violations
nb_decision_points                   | INT      | (Metric #10506) Total number of decision points
nb_files                             | INT      | (Metric #10154) Total number of files
nb_tables                            | INT      | (Metric #10163) Total number of tables
nb_violations                        | INT      | (Metric #67211) Total number of violations
technical_debt_density               | DECIMAL  | (Metric #68002) Technical Debt density estimates the cost per thousand of lines of code to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
technical_debt_total                 | DECIMAL  | (Metric #68001) Technical Debt estimates the cost to fix a pre-set percentage of high severity violations, of medium severity violations, and of low severity violations
```

### MOD_HEALTH_SCORES
Score and number of violations by snapshot, by module and by business criterion
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
snapshot_id                          | TEXT     | The concatenation of the application name and the snapshot timestamp
module_name                          | TEXT     | Module name
business_criterion_name              | TEXT     | Business Criterion Name (Total Quality Index, Security, etc.)
is_health_factor                     | BOOLEAN  | Check whether this business criterion is a health factor
nb_critical_violations               | INT      | (Metric #67011) Business Criterion score
nb_violations                        | INT      | (Metric #67211) Business Criterion score
score                                | DECIMAL  | Business Criterion score
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
score                                | DECIMAL  | Quality Indicator grade
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
```

### STD_RULES
Mapping of Rules with Quality Standards references
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
metric_id                            | INT      | AIP Globally unique metric ID
tag                                  | TEXT     | Quality Standard reference (aka tag)
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
                                     |          | Cost complexity (-1: n/a, 0:low, 1:moderate, 2:high, 3:very-high) is a risk assessment calculated from risk assessments of
                                     |          | - Cyclomatic complexity
                                     |          | - SQL cyclomatic complexity
                                     |          | - Granularity
                                     |          | - Lack of comments
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

### SRC_TRX_OBJECTS
Source objects of transactions
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
trx_id                               | INT      | The transaction ID from the SRC_TRANSACTIONS table
object_id                            | INT      | The source object ID, member of the transaction from the SRC_OBJECTS table
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

### USR_ACTION_PLAN
Users Requests to remediate violations. Note that a violation can be solved and raised again. Deactivated rules are not reported.
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
application_name                     | TEXT     | Application name
rule_id                              | TEXT     | Local rule ID is the concatenation of the application name and the AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
object_id                            | INT      | Concatenation of application name and object internal unique ID from central Base
object_name                          | TEXT     | Object name
action_status                        | TEXT     | Status regarding the latest snapshot: added, pending, solved (ie fixed)
last_update_date                     | DATE     | Date of last edition update
start_date                           | DATE     | The creation date of the action plan issue
end_date                             | DATE     | The resolution date of the action plan issue
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
rule_name                            | TEXT     | Rule name
object_id                            | INT      | Concatenation of application name and object internal unique ID from central Base
object_name                          | TEXT     | Object name
user_name                            | TEXT     | The author of the exclusion request
comment                              | TEXT     | Comment describing the reason of the exclusion
```

## Measurement Queries: Basic Examples

### Number of Critical Violations by Business Criterion

Query:
```
select sum(t.nb_critical_violations), t.business_criterion_name
from dim_snapshots s
join app_health_scores t on t.snapshot_id = s.snapshot_id 
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

### Total Technical Debt

Query:
```
select sum(technical_debt_total)
from app_sizing_measures m
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
from app_sizing_measures m
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
join dim_quality_standards q on q.metric_id = m.metric_id and q.aip_top_priority
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
from app_health_scores m
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
join dim_quality_standards q on q.metric_id = m.metric_id and q.owasp_2017
where m.nb_violations <> 0 
order by nb_violations desc
```

Data output:
```
7906|"Avoid testing specific values for SY-UNAME"|"ABAP"|1
```


## Measurement Queries: Advanced Examples

### Ratio of Critical Violations per Function Point

Query:
```
select
(select sum(m.nb_violations)::numeric
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

## Findings Queries Examples

### Find quick-win critical rules to fix OWASP-2017 A1-Injection vulnerabilities

Find rules that are worth to fix regarding the number of findings and the associated risk

```
select s.application_name, v.metric_id, r.rule_name, r.weight, sum(v.nb_findings) as nb_findings, 
max(v.finding_type) as type, count(*) as nb_violations
from src_violations v
join dim_rules r on r.rule_id = v.rule_id and r.is_critical
join std_rules t on t.metric_id = v.metric_id and t.tag = 'A1-2017'
join dim_snapshots s on v.snapshot_id = s.snapshot_id and s.is_latest 
group by 1,2,3,4
order by 5,4 asc
```

Data output:

application_name|metric_id|rule_name|weight|nb_findings|type|nb_violations
----------------|--------|----------|------|-----------|----|-------------
"Jurassic Park"|7750|"Avoid XPath injection vulnerabilities"|9.0|1|"path"|1
"Jurassic Park"|8218|"Content type should be checked when receiving a HTTP Post"|8.0|2|"bookmark"|2
"Jurassic Park"|8098|"Avoid uncontrolled format string"|9.0|2|"path"|1
"Dream Team"   |7748|"Avoid OS command injection vulnerabilities"|9.0|2|"path"|1
"Jurassic Park"|7746|"Avoid LDAP injection vulnerabilities"|9.0|2|"path"|1
"Jurassic Park"|7748|"Avoid OS command injection vulnerabilities"|9.0|4|"path"|3


### Find quick-win objects to fix OWASP-2017 A1-Injection vulnerabilities

Find violations that are worth to fix regarding the number of findings and the associated risk

```
select s.application_name, m.module_name, v.metric_id, r.rule_name, o.cost_complexity, h.propagated_risk_index, '...' || right(o.object_full_name, 30), 
v.finding_type as type
from src_violations v
join dim_rules r on r.rule_id = v.rule_id and r.is_critical
join std_rules t on t.metric_id = v.metric_id and t.tag = 'A1-2017'
join dim_snapshots s on v.snapshot_id = s.snapshot_id and s.is_latest 
join src_objects o on o.object_id = v.object_id
join src_health_impacts h on h.object_id = v.object_id and h.business_criterion_name = 'Security'
join src_mod_objects m on m.object_id = v.object_id
where v.metric_id in (7750,8218,8098,7748,7746,7748)
```

Data output:

application_name|module_name|metric_id|rule_name|cost_complexity|propagated_risk_index|object_full_name|type
--------------|-----------|---------|---------|---------------|---------------------|----------------|----
"Dream Team"|"Adg"|7748|"Avoid OS command injection vulnerabilities"|0|180.0|"...Default Package>.DynGraph.init"|"path"
"Jurassic Park"|"WASecu"|7746|"Avoid LDAP injection vulnerabilities"|0|1620.0|"...tyForm._Default.GetRawInputGet"|"path"
"Jurassic Park"|"JSPBookDemo"|7748|"Avoid OS command injection vulnerabilities"|1|740.0|"...ld.servlet.FrontServlet.doPost"|"path"
"Jurassic Park"|"JSPBookDemo"|7748|"Avoid OS command injection vulnerabilities"|1|1110.0|"...rk.servlet.FrontServlet.doPost"|"path"
"Jurassic Park"|"WASecu"|7748|"Avoid OS command injection vulnerabilities"|0|1620.0|"...tyForm._Default.GetRawInputGet"|"path"
"Jurassic Park"|"WASecu"|7750|"Avoid XPath injection vulnerabilities"|0|1620.0|"...tyForm._Default.GetRawInputGet"|"path"
"Jurassic Park"|"JSPBookDemo"|8098|"Avoid uncontrolled format string"|1|690.0|"....controler.SalesControler.init"|"path"
"Jurassic Park"|"JSPBookDemo"|8218|"Content type should be checked when receiving a HTTP Post"|1|740.0|"...ld.servlet.FrontServlet.doPost"|"bookmark"
"Jurassic Park"|"JSPBookDemo"|8218|"Content type should be checked when receiving a HTTP Post"|1|1110.0|"...rk.servlet.FrontServlet.doPost"|"bookmark"

