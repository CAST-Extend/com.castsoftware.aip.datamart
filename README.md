# Beta Version

The Datamart scripts and Datamart Web Services of Dashboards REST API are in BETA version.

REST API version to use is the latest version (**1.13.2** or higher).

## Contents

- [Purpose](#purpose)
- [Limitations](#limitations)
- [How to Build the AIP Datamart](#how-to-build-the-aip-datamart)
- [How to Use the AIP Datamart ](#how-to-use-the-aip-datamart)
- [Summary of Tables](#summary-of-tables)
- [Data Dictionary](#data-dictionary)
- [Measurement Queries: Basic Examples](#measurement-queries-basic-examples)
- [Measurement Queries: Advanced Examples](#measurement-queries-advanced-examples)
- [Findings Queries Examples](#findings-queries-examples)


## Purpose
The AIP datamart is a simple database schema of AIP results, so that anyone can query these data, requiring only conceptual knowledge of AIP.

The AIP Datamart can be used:
* to query AIP data from a Business Intelligence tool such as Power BI Desktop
* to query AIP data using SQL  queries
* to create CSV report using SQL queries and the CSV export capability of postgreSQL

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
* The scope of data is the measurement base results (however you can extract from a measurement base or a central base)
* The effective extracted data depend on the user's authorizations running the REST API from the extraction scripts. 
If the user is not granted to access to all applications, then some data will be skipped.
If the user is granted to access all applications, then, the user will expose all data in the target database.
* All data relative to Quality Distributions are skipped. 
* All data relative to Quality Measures are skipped.
* The list of Business Criteria is closed. Custom business criteria are skipped.

## How to Build the AIP Datamart

### The Scripts

The scripts are *.BAT files for Windows operating systems

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

### Running the Scripts

* Make sure you have access to 
  * the REST API server (__1.13.2_ or higher)
  * a PostgreSQL server, with a database created to host target data
  * __[curl](https://curl.haxx.se/download.html)__ command line (in your path)
  * __[Python 3](https://www.python.org/downloads/)__ (in your path)
* Edit the scripts ```setenv.bat``` to set the configuration variables
  * Folders
      * ```INSTALLATION_FOLDER```: the absolute path of the scripts location
  * REST API
      * ```ROOT```: URL to a REST API, ex: ```http://localhost:9090/CAST-RESTAPI/rest```
      * ```DOMAIN```: the REST API domain name, ex: ```AAD``` for the measurement base, or an Engineering Dashboard domain
      * ```QSTAGS```: the Quality Standard tags 
  * Target Database
      * ```PSQL```: the absolute path to the psql command (see your PostgreSQL install directory)
      * ```VACUUMDB```: the absolute path to the vacummdb command (see your PostgreSQL install directory)
      * ```_DB_HOST```: the PostgreSQL server host name
      * ```_DB_PORT```: the PostgresQL server port
      * ```_DB_NAME```: the target PostgresSQL database
      * ```_DB_USER```: the PostgreSQL user name 
      * ```_DB_SCHEMA```: the target schema name
* Set PostgreSQL server password:
    * Either in ```PGPASSWORD``` environment variable
    * Or in ```%APPDATA%\postgresql\pgpass.conf``` file which must have restricted access (see [PostgreSQL Documentation: The password file](https://www.postgresql.org/docs/9.3/libpq-pgpass.html))
* Set credentials to authenticate to the REST API (see Curl command line)
    * Either in ```CREDENTIALS``` environment variable with the following format ```username:password```
    * Or in ```%USERPROFILE%/_netrc``` file which must have restricted access, append these 3 text lines:
      ```
      machine <hostname>
      login <username>
      password <password>
      ```
* Then start ```run.bat install``` from a CMD window (do not double click from the explorer)
* In case of errors, you will find a message on the standard output and some additional messages in the ```ETL.log``` file.

After a first install, if you start ```run.bat refresh```, the script will just truncate the datamart tables before re-loading data, preserving custom tables and views that depends on datamart tables.

Start ```run.bat help``` for more information on these modes.

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

To add these 2 database views to the Datamart schema, runs `create_views.bat` file from your installation directory:
```
C:\>create_views
```
## Summary of Tables

### Dimension Tables

These tables can be used to filter data along "Dimension":
* `DIM_RULES`: A Dimension table to filter measures according to rules contribution

* `DIM_QUALITY_STANDARDS`: A Dimension table to filter measures according to Quality Standards

* `DIM_SNAPSHOTS`: A Dimension table to filter measures according to a period

* `DIM_APPLICATIONS`: A Dimension table to filter measures according to Application Tags (Measurement base)

### Measures Tables

Application Measures of tables can be safely aggregated (average, sum) with a BI tool.
<br/>
__WARNING__: You cannot aggregate measures for a set of modules because of modules overlapping. However, you can aggregate measures for a specific module name.

Scope|Applications Table|Modules Table
-----|------------|-------
Violations <sup>(1)</sup>|`APP_VIOLATIONS_MEASURES`|`MOD_VIOLATIONS_MEASURES`
Sizing Measures|`APP_SIZING_MEASURES`|`MOD_SIZING_MEASURES`
Health Measures|`APP_HEALTH_MEASURES`|`MOD_HEALTH_MEASURES`
Functional Sizing Measures|`APP_FUNCTIONAL_SIZING_MEASURES`|N/A

(1): Split by technology

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
Source objects|`SRC_VIOLATIONS`
Users requests|`USR_EXCLUSIONS`
Users requests|`USR_ACTION_PLAN`

## Data Dictionary

### DIM_APPLICATIONS
A Dimension table to filter measures according to Application Tags. The COLUMN names depend on the end-user categories. We give an example here based on the demo site:

```
COLUMN                        | TYPE     | DESCRIPTION
------------------------------+----------+-----------
application_name"             | INT      | Table primary key
"Age"                         | TEXT     | A range of ages of the application
"Business Unit"               | TEXT     | The Business Unit as a sponsor or provider of the application
"Country"                     | TEXT     | The deployment country of the application
"Release Frequency"           | TEXT     | The release frequency of the application
"Sourcing"                    | TEXT     | The out sourcing company
"Methodology"                 | TEXT     | The application development approach
```

### DIM_QUALITY_STANDARDS
A Dimension table to filter measures according to Quality Standards. 
* in case of a data extraction from a central base, the Quality Standard extension version must be __20181030__ or higher; it is recommended to install the __20190923__ version or higher to get the OMG standards
* in case of a data extraction from a measurement base, the measurement base must be __8.3.5__ or higher 

The COLUMN names depend on the selected tags of the query parameter of the Web Service "dim-quality-standards".
See the [CAST Rules Documentation Portal](https://technologies.castsoftware.com) to get the available Quality Standards tags.
<br>
Example of columns for the URI:
```/AAD/datamart/dim-quality-standards?tags=AIP-TOP-PRIORITY-RULE,CWE,OMG-ASCQM-Security,OWASP-2017```
<br>

```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
metric_id                            | INT      | AIP Globally unique metric ID
rule_name                            | TEXT     | Rule name
aip_top_priority                     | BOOLEAN  | Check whether this rule is a top priority rule according to AIP
cwe                                  | BOOLEAN  | Check whether this rule detects a CWE weakness
omg_ascqm_security                   | BOOLEAN  | Check whether this rule detects OMG/CISQ 2019 weakness
owasp_2017                           | BOOLEAN  | Check whether this rule detects a top 10 OWASP 2017 vulnerability
```

### DIM_SNAPSHOTS
A Dimension table to filter measures according to a period. 
* Column YEAR, YEAR_MONTH, YEAR_QUARTER, YEAR_WEEK are set only for the most recent snapshot of this period for this application; they are provided to filter snapshots for a specific period
* These columns make sense when applications are periodically analyzed. For instance, if each application is analyzed once a year, then  we can use the column YEAR as a filter; if some applications are not analyzed every week; then the YEAR_WEEK filter must be used carefully. 
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
### APP_HEALTH_MEASURES
Measures by application snapshot, by business criterion
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

### MOD_HEALTH_MEASURES
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

### SRC_HEALTH_IMPACTS
Propagated Risk Index, and Risk Propagation Factor by Business Critarion and Source Object
```
COLUMN                               | TYPE     | DESCRIPTION
-------------------------------------+----------+------------
object_id                            | INT      | Concatenation of application name and object internal unique ID from central Base
object_name                          | TEXT     | Object name
business_criterion_name              | TEXT     | A business criterion
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
                                     |          | Cost complexity (low, moderate, high, very-high) is a risk assessment calculated from risk assessments of
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
finding_type                         | TEXT     | Type of finding among ["number", "percentage", "text", "object", "date", "integer", "no-value", "path", "group", "boomark"]
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
action_status                        | TEXT     | Status regarding the latest snapshot: added, pending, solved
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

### Find quick-win critical OWASP-2017 top 10 vulnerabilities by rules and source objects

List of violations (pair of source object, rule) that are worth to fix regarding the number of findings and the associated risk

```
select r.rule_name, m.metric_id, o.object_id, o.object_name, v.nb_findings, m.nb_violations, m.nb_total_checks
from src_violations v
join dim_rules r on r.rule_id = v.rule_id and r.is_critical -- **CRITICAL**
join app_violations_measures m on m.rule_id = v.rule_id and v.snapshot_id = m.snapshot_id
join dim_quality_standards s on s.metric_id = m.metric_id and s.owasp_2017 -- **OWASP-2017** 
join src_objects o on o.object_id = v.object_id
where nb_violations <= 5 -- **QUICK WIN**
order by 2
limit 5
```

Data output:

Rule Name                                                     |Rule ID| Object ID|Object Short Name|Nb findings|Nb violations|Nb total checks
--------------------------------------------------------------|-------|----------|-----------------|-----------|-------------|---------------
Content type should be checked when receiving a HTTP Post     |8218   | 2181120  | doGet           |1          |1            |1
Avoid using submit markup related to form" with id attribute" |1020024| 2138342  | login.html      |1          |2            |254
Avoid using submit markup related to form" with id attribute" |1020024| 2495182  | login.html      |1          |2            |254
Ensure the Content-Security-Policy is activated (Node.js)     |1020706| 2498468  | dev-server.js   |1          |1            |1
Ensure the X-Powered-By header is disabled                    |1020708| 2498468  | dev-server.js   |1          |1            |1
...


### Variant #1: Find quick-win critical OWASP-2017 top 10 vulnerabilities by rules

List of rules that are worth to fix regarding the number of findings and the associated risk

```
select r.rule_name, m.metric_id, sum(v.nb_findings), max(m.nb_violations) 
from src_violations v
join dim_rules r on r.rule_id = v.rule_id and r.is_critical -- **CRITICAL**
join app_violations_measures m on m.rule_id = v.rule_id and v.snapshot_id = m.snapshot_id
join dim_quality_standards s on s.metric_id = m.metric_id and s.owasp_2017 -- **OWASP-2017**
where nb_violations <= 5 -- **QUICK WIN**
group by 1,2
order by 3 asc
limit 5
```

Data output:

Rule Name|Rule ID|Nb of findings|Nb of violations
---------|-------|--------------|----------------
Ensure the X-Frame-Options header is setup (Node.js)|1020712|1|1
Avoid using deprecated SSL protocols to secure connection|1039002|1|1
Ensure the Content-Security-Policy is activated (Node.js)|1020706|1|1
Ensure setting Content-Security-Policy for spring application.|1040006|1|1
Allow only HTTPS communication|1020720|1|1


### Variant #2: Find quick-win critical OWASP-2017 top 10 vulnerable source objects

List of objects that are worth to fix regarding the number of findings and the associated risk

```
select  o.object_id, o.object_name, sum(v.nb_findings)
from src_violations v
join dim_rules r on r.rule_id = v.rule_id and r.is_critical -- **CRITICAL**
join app_violations_measures m on m.rule_id = v.rule_id and v.snapshot_id = m.snapshot_id
join dim_quality_standards s on s.metric_id = m.metric_id and s.owasp_2017  -- **OWASP-2017**
join src_objects o on o.object_id = v.object_id
where nb_violations <= 5 -- **QUICK WIN**
group by 1,2
order by 3 desc
limit 5
```

Data Output:

Object ID|Object Short Name|Number of findings
---------|-----------------|------------------
2498468|dev-server.js|6
2724701|configure|5
2026699|HttpRequestManager|3
2716201|transform|2
2729063|_get_image_properties|2


