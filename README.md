See the [release notes](RELEASE_NOTES.md) for the compatible REST API versions.

## Contents

- [Contents](#Contents)
- [Purpose](#Purpose)
- [Limitations](#Limitations)
- [Terms and Conditions](#Terms-and-Conditions)
- [How to Build the AIP Datamart](#How-to-Build-the-AIP-Datamart)
    - [The Scripts](#The-Scripts)
    - [Running the Scripts ](#Running-the-Scripts)
        - [Password obfuscation](#Password-obfuscation)
        - [Single Data Source](#Single-Data-Source)
        - [Multiple Data Sources](#Multiple-Data-Sources)
        - [Datamart Dedicated user](#Datamart-Dedicated-User)
        - [Troubleshooting Guide](#Troubleshooting-Guide)
    - [Schema Upgrade](#Schema-Upgrade)
    - [Datapond](#Datapond)    
- [How to Use the AIP Datamart](#How-to-Use-the-AIP-Datamart)
    - [Grant Access to Users](#Grant-Access-to-Users)
    - [Custom Tables and Views](#Custom-Tables-and-Views)
    - [CSV Reports](#CSV-Reports)
    - [Power BI Desktop](#Power-BI-Desktop)
- [Summary of Tables](#Summary-of-Tables)
    - [Dimension Tables](#Dimension-Tables)
    - [Basic Facts (Central Database only)](#Basic-Facts-Central-Database-only)
    - [Basic Measures Tables](#Basic-Measures-Tables)
    - [Aggregated Measures by Application/Module](#Aggregated-Measures-by-Application-Module)
    - [Scores](#Scores)
    - [Other tables](#Other-tables)
- [Data Dictionary](data_dictionary.md)
- [Measurement Queries: Basic Examples](#Measurement-Queries-Basic-Examples)
- [Measurement Queries: Advanced Examples](#Measurement-Queries-Advanced-Examples)
- [Findings Queries Examples](#Findings-Queries-Examples)

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
See also: See [Datamart dedicated user](#Datamart-Dedicated-User)
* For the DIM_RULES table, the list of Business Criteria is closed. Custom business criteria are skipped.
* The Datamart takes a kind of snapshot of the published data, so the Datamart scripts must be run outside a source code analysis or a metrics calculation.
* The Datamart fails when a technical criteron is not attached to the Technical Quality Index (#60017 - TQI). This configuration is not supported by the Datamart, but neither is it supported by the platform, as it creates an inconsistency between metrics calculated with results attached to the TQI and those calculated globally.

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
  * a PostgreSQL server 9.6 or higher, with a database created to host target data
* __Download__ the Datamart scripts from [extend.castsoftware.com](https://extend.castsoftware.com/#/search-results?q=datamart) package
     * Unzip the archive, and move the content into a single target folder
     * Note: you do not need to install any software, all the required embedded softwares are available in the ```thirdparty``` directory
* __Edit configuration variables__ in ```setenv.bat``` file
  * Target Database:
      * ```_DB_HOST```: the PostgreSQL server host name
      * ```_DB_PORT```: the PostgreSQL server port
      * ```_DB_NAME```: the target PostgreSQL database
      * ```_DB_USER```: the PostgreSQL user name 
      * ```_DB_SCHEMA```: the target schema name
  * __Set PostgreSQL server password__ in ```PGPASSWORD``` environment variable
  * __Set credentials__ to authenticate to the REST API in ```CREDENTIALS``` environment variable with the following format ```username:password``` or set the ```APIKEY``` and ```APIUSER``` environment variables
  * __Set the extraction scope__:
      * ```EXTRACT_DATAPOND```: When this variable is set to ```ON```, then the ```DATAPOND_ORGANIZATION``` table is extracted as an alternative to the ```DIM_APPLICATIONS``` table
      * ```EXTRACT_MOD```: When this variable is to ```OFF```, then the ```*MOD*``` tables are skipped.   
      * ```EXTRACT_TECHNO```: When this variable is to ```OFF```, then the ```*TECHNO*``` tables are skipped.   
      * ```EXTRACT_SRC```: When this variable is to ```OFF```, then the ```*SRC*``` tables are skipped.   
      * ```EXTRACT_USR```: When this variable is to ```OFF```, then the ```*USR*``` tables are skipped.   
  * __Set the debug mode for data checking__:
      * ```DEBUG```: When this variable is to ```ON```, then the ```extract``` and ```transform``` folders are not clean up.
  * __Copy the JAR__
      * Starting from REST API 2.4.0, if you have deployed the Dashboards/REST API with Tomcat, you can overwrite the REST API backend so that you do not need to upgrade the REST API and/or the Dashboards. Replace the Datamart JAR file of the WEB-INF\lib folder of your deployed Tomcat webapp with the JAR file from the ```lib``` folder of the Datamart distribution.

_Note_: If you set an environment variable with a special character such as ```&<>()!``` then you MUST NOT use double-quotes, but escape the characters with ```^``` character:
```
REM John is the user name and R2&D2! is the password
SET CREDENTIALS=John:R2^&D2^^!
```

You can avoid this kind of issue, using the obfuscation mechanism.

#### Password obfuscation

You can obfuscate the ```CREDENTIALS```, ```PGPASSWORD```, ```APIKEY```, ```APIUSER``` environment variables as follow:

```
C:>python utilities\encode.py mysecret
HEX:773654446d734f6c773550446a4d4f6777347a4372673d3d

SET PGPASSWORD=HEX:773654446d734f6c773550446a4d4f6777347a4372673d3d
```
This obfuscation prevents the [shoulder surfing](https://en.wikipedia.org/wiki/Shoulder_surfing_%28computer_security%29). It does not prevent an operator to access the secret values in clear text.

#### Single Data Source

This mode allows to extract data of a single Health domain or a single Engineering domain into a target database.

* __Edit__ the scripts ```setenv.bat``` to set the default REST API URL and DOMAIN
  * ```DEFAULT_ROOT```: URL to a REST API, ex: ```http://localhost:9090/rest```
  * ```DEFAULT_DOMAIN```: the REST API domain name, ex: ```AAD``` for the Health domain, or an Engineering domain
* __Start__ ```run.bat install``` 
* In case of errors, you will find a message on the standard output and some additional messages in the ```log``` directory.

After a first install, if you start ```run.bat refresh```, the script will just truncate the datamart tables before re-loading data, preserving custom tables and views that depends on datamart tables.

Start ```run.bat help``` for more information on these modes.

#### Multiple Data Sources

This mode allows to extract data from an Health domain (```AAD```), and all related Engineering domains into a single target database.

__WARNING:__ this mode may consume a lot of resources (CPU, disk space). We advise to limit the extraction scope with environment variables.

* __Edit__ the ```setenv.bat``` script to override the following environment variables:
  * ```HD_ROOT```: URL to the REST API hosting the ```AAD``` domain
  * ```ED_ROOT[0]```: URL to the REST API hosting the engineering domains; this URL can be the same as the ```HD_ROOT```
  * ```ED_ROOT[1]```: URL to a second REST API hosting the engineering domains  
  * ```JOBS```: the number of concurrent transfer processes. By default the number is 1 for a sequential mode. Do not exceed the maximum number of DBMS connections on REST API side, which is 10 by default.
* __Start__ ```datamart.bat install``` from a CMD window (do not double click from the explorer)
* In case of errors, you will find a message on the standard output and some additional messages in the ```log``` directory.

After a first install, if you start ```datamart.bat refresh```, the script will just truncate the datamart tables before re-loading data, preserving custom tables and views that depends on datamart tables.

If you start ```datamart.bat update```, the script will synchronize the datamart with new snapshots; saving extract and loading time.

#### Datamart Dedicated User

We advise to create a Datamart dedicated user for the [Dashboards REST API](https://doc.castsoftware.com/display/DASHBOARDS/User+roles+-+2.x+and+above).
This user should be authorized to access all applications.
If ever you need to skip some applications for the extraction process, then you will be able to remove these applications from the set of authorized applications for this user (make sure this user has no "admin" role).

#### Troubleshooting Guide

__&#9888; All extract tables are empty__

Make sure your service account is authorized to access the applications.

__&#9888; Some columns (```nb_complexity_xxx```, ```nb_cyclomatic_xxx```) are empty__

These measures correspond to "distribution" type metrics.
If you extract data from a measurement base only (using the ```run.bat``` script), then these measures will be missing.
You will have to consider multiple data source extraction from central bases to get these measures (using the ```datamart.bat``` script).
In this case, to limit the volume and extraction time, it is possible to deactivate the extraction of source objects and user data (action plan), by adding in ```setenv.bat``` :
```
set EXTRACT_SRC=OFF
set EXTRACT_USR=OFF
```

__&#9888; I have got an "Access Denied" message__

Make sure you have write access on the Datamart folder.

__&#9888; A foreign constraint on DIM_RULES table is violated__

This may happen because of these two limitations:
- The Datamart scripts must be run outside a source code analysis or a metrics calculation.
- The Datamart fails when a technical criteron is not attached to the Technical Quality Index (#60017 - TQI).

See [Limitations](#Limitations)

__&#9888; The data transfer fails on the load step__

The Datamart scripts fails with a message such as:
> Data transfer ABORTED for domain XXX<br>
> Datamart install Fail

And in the log\XXX.log file you can find this SQL error message:
>DETAIL: Key (previous_snapshot_id)=(XXXXXXX:2020-11-10 23:46:00) is not present in table "dim_snapshots"

Any bad reference to the ```dim_snapshots``` table denotes an erroneous snapshot.
This snapshot should be removed from the central base, and the measurement base, using AIP tools.

__&#9888; The Datamart scripts are stuck__

If the extraction step is never ending, then look at the Web Server (Tomcat) log to check whether there is a Java Memory error: "Ran out of memory".
- In case of a single data source extraction, you will have to increase the memory or the Tomcat server.
- In case of a multiple data source extraction, you can either increase the memory of the Tomcat server or decrease the number of jobs (see ```JOBS``` variable).

You can check the total memory currently use by the Web Server with this call:
```
curl -u %CREDENTIALS% "%ROOT%/server"  
```
The response reports the initial memory size (mega-bytes) when Tomcat has been started, and the total memory size (mega-bytes) required until now:
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

__&#9888; During Datamart execution, the Dashboards are slowing down__

This may appear if the number of ```JOBS``` plus the number of concurrent users exceed the maximum size of the database connection pool on REST API side.
You must take care to not exhaust the number of Database server connections. In other words, you may need to decrease the number of ```JOBS``` or increase the size of the connection pool:

For example: Let's set 20 connections = 10 connections for concurrent users + 10 connections for Datamart (```set JOBS=10```):
- For REST API 2.X: 
```
restapi.datasource[0].maximumPoolSize=20
```
- For REST API 1.X:
```
<Resource name="jdbc/domains/LOCALHOST" url="jdbc:postgresql://localhost:2282/postgres" ... initialSize="5" maxTotal="20" maxIdle="10" maxWaitMillis="-1"/>
```

__&#9888; The ```datamart``` command line is taking too much time__

Firstly, you can parallelize the extraction with concurrent processes by settings the ```JOBS``` variable. See [Running the Scripts ](#Running-the-Scripts)

Secondly, you can reduce the extraction scope either by extracting only the measurement base with the ```run``` command or by ignoring some set of tables that you do not need. See [Running the Scripts ](#Running-the-Scripts)

At last, you can use the ```datamart update``` command line in order to synchronize the datamart with new snapshots only.

### Schema Upgrade

If the Datamart schema has been extended with new tables, or new columns, you may need to perform some actions.

- If you are using ```run install``` or  ```datamart install``` command line, then you do not need to do anything.
      
- If you are using ```run refresh``` or  ```datamart refresh``` command line to preserve some SQL Views, then you need to:
    - run the ```upgrade_schema.bat``` script to install new tables and columns,
    - you may need to reinstall the impacted views with ```create_views.bat``` and ```create_datapond_views.bat```

- If you are using ```datamart update``` command line to refresh data coming only from new snapshots, then you need to:
    - run the ```upgrade_schema.bat``` script to install new tables and columns,
    - you may need to reinstall the impacted views with ```create_views.bat``` and ```create_datapond_views.bat```
    - run the ```datamart refresh``` before the next ```datamart update``` run
    
### Datapond

To comply with the DATAPOND extract tables and to limit the resources consumption (CPU, disk space), we advise to set the extract environment variables as follow:
```
set EXTRACT_DATAPOND=ON
set EXTRACT_MOD=OFF
set EXTRACT_TECHNO=OFF
set EXTRACT_SRC=OFF
set EXTRACT_USR=ON
```

This toolkit provides some Datapond compliant views:
* [views/BASEDATA_FLAT.sql](views/BASEDATA_FLAT.sql): this view transposes business criteria scores to columns, and provides new metrics using SQL expressions.
* [views/COMPLETE_FLAT.sql](views/COMPLETE_FLAT.sql): this view extends the BASEDATA_FLAT view with AEP measures, and adds AEP based metrics using the SQL average operator.
* [views/DATAPOND_BASEDATA.sql](views/DATAPOND_BASEDATA.sql): this view reports the DATAPOND_BASEDATA table rows. 
* [views/DATAPOND_VIOLATIONS.sql](views/DATAPOND_VIOLATIONS.sql): this view reports the DATAPOND_VIOLATIONS table rows. 
* [views/DATAPOND_AP.sql](views/DATAPOND_AP.sql): this view reports the DATAPOND_AP table rows (Action Plan Issues).
* [views/DATAPOND_PATTERNS.sql](views/DATAPOND_PATTERNS.sql): this view reports the DATAPOND_PATTERNS table rows.


For BASEDATA_FLAT and COMPLETE_FLAT views, the differences with Datapond 5.1 corresponding views are as follow:
* Some columns are missing 
  * the `technologies` column has been removed
  * EFP columns have been removed; because these values are replaced with AEP metrics 
* For some data, the precision for decimal values may differ; because the Datapond applies some pre-rounding with Python scripts using the "rounding half to even" strategy, which is not the PostgreSQL rounding strategy
* When AEP has not be calculated for a snapshot, the Datamart reports the 'null' value, whereas the Datapond reports the value of the next snapshot
* The calculation of averages has been fixed

To add these database views to the Datamart schema, runs `create_datapond_views.bat` file from your installation directory:
```
C:\>create_datapond_views
```


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

### Custom Tables and Views

In ```refresh``` mode, the scripts will truncate the Datamart tables. All other tables and views are left unchanged.

In ```install``` mode, the scripts will drop and recreate Datamart tables. However, you can add your own tables. Indeed, when you run the scripts it leaves these tables unchanged. Only the database views must be recreated.

Note: You can isolate your custom tables and views in a separate schema, ```my_schema``` for example.

With the SQL statement ```set search_path to datamart,my_schema;``` you will have access to both datamart tables/views and your own tables/views

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
* For latest release of Power BI:
    * Install the Power BI Desktop tool from [Microsoft marketplace](https://powerbi.microsoft.com/en-us/downloads/)
    * Import AIP Datamart tables using the PostgreSQL plugin

* For Power BI Desktop versions released before December **2019**, you must install **NpgSQL** (.NET data provider for PostgreSQL) on your local machine:
    * Download [.NET data provider for PostgreSQL](https://github.com/npgsql/npgsql/releases/download/v4.0.12/Npgsql-4.0.12.msi)
    * Install **NpgSQL** as Administrator (since the DLL would be pushed to GAC - Global Assembly Cache). During the installation stage, enabled "NpgSQL GAC Installation"
    * Restart the PC, then launch Power BI Desktop
    * Import AIP Datamart tables using the PostgreSQL plugin

## Summary of Tables

### Dimension Tables

These tables can be used to filter data along "Dimension":
* `DIM_RULES`: A Dimension table to filter measures according to rules contribution

* `DIM_OMG_RULES`: A Dimension table to filter measures according to rules contribution to ISO index

* `DIM_CISQ_RULES`: A Dimension table to filter measures according to rules contribution to CISQ index
* `DIM_QUALITY_STANDARDS`: A Dimension view to filter measures according to Quality Standards

* `DIM_OMG_ASCQM`: An optional<sup> (1)</sup> Dimension view to filter measures according to the ISO standard criteria

* `DIM_OWASP_2017`: A optional<sup> (1)</sup> Dimension view to filter measures according to OWASP 2017 Top 10 vulnerabilities

* `DIM_SNAPSHOTS`: A Dimension table to filter measures according to a period

* `DIM_APPLICATIONS`: A Dimension table to filter measures according to Application Tags (Measurement base)

(1): Optional means that the view is not created by default. Run `create_views.bat` file from your installation directory.

### Basic Facts (Central Database only)

These results can be safely aggregated according to all dimensions.

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

### Basic Measures Tables

These results tables are split by technology, and/or rules.
These results can be aggregated with a BI tool.
Application Measures of tables can be safely aggregated (average, sum) with a BI tool.
<br/>
__WARNING__: You cannot aggregate measures for a set of modules because of modules overlapping. However, you can aggregate measures for a specific module name.

Scope|Applications Table|Modules Table
-----|------------|-------
Violations Measures |`APP_FINDINGS_MEASURES`<sup> (1)</sup>|None
Violations Measures |`APP_VIOLATIONS_MEASURES`|`MOD_VIOLATIONS_MEASURES`
Violations Measures |`APP_VIOLATIONS_EVOLUTION`|`MOD_VIOLATIONS_EVOLUTION`
Sizing Measures|`APP_TECHNO_SIZING_MEASURES`|`MOD_TECHNO_SIZING_MEASURES`
Sizing Measures Evolution|`APP_TECHNO_SIZING_EVOLUTION`|`MOD_TECHNO_SIZING_EVOLUTION`

(1) Extracted from central databases only

### Aggregated Measures by Application/Module

These results are pre-calculated accross technologies and rules.
These results can be in turn aggregated with a BI tool. Application Measures of tables can be safely aggregated (average, sum) with a BI tool.
<br/>
__WARNING__: You cannot aggregate measures for a set of modules because of modules overlapping. However, you can aggregate measures for a specific module name.

Scope|Applications Table|Modules Table
-----|------------|-------
Aggregated Sizing Measures|`APP_SIZING_MEASURES`|`MOD_SIZING_MEASURES`
Aggregated Functional Sizing Measures|`APP_FUNCTIONAL_SIZING_MEASURES`|N/A
Aggregated Health Measures Evolution|`APP_HEALTH_EVOLUTION`|`MOD_HEALTH_EVOLUTION`
Aggregated Sizing Measures Evolution|`APP_SIZING_EVOLUTION`|`MOD_SIZING_EVOLUTION`
Aggregated Functional Sizing Evolution|`APP_FUNCTIONAL_SIZING_EVOLUTION`|N/A

### Scores

These results are scores that cannot be easily aggregated with a BI tool. Indeed, the scores are calculated using weighted averages, critical flags, and thresholds for rules.

Scope|Applications Table|Modules Table
-----|------------|-------
Health (Business Criteria) Scores|`APP_HEALTH_SCORES`|`MOD_HEALTH_SCORES`
All Scores by Application and Module|`APP_SCORES`|`MOD_SCORES`
All Scores split by Technology|`APP_TECHNO_SCORES`|`MOD_TECHNO_SCORES`

### Other tables

Scope|Table
-----|------------
Quality Standards Mapping|`STD_RULES`
Quality Standards Mapping|`STD_DESCRIPTIONS`

## Data Dictionary

See [Data Dictionary](data_dictionary.md)

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

### Top 10 rules by snapshot, technology, number of violations

Query:
```
select r.*, t.technology, t.nb_violations
from
( select snapshot_id, rule_id, technology, nb_violations,  
  row_number() over (partition by snapshot_id, technology order by snapshot_id, technology, nb_violations desc) as rnb
  from app_violations_measures
) as t
join dim_rules r on r.rule_id = t.rule_id
where t.rnb <= 10;
```

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

