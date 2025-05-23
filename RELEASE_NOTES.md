## Version: 3.0.0 - 20 April 2025

#### Compatibility

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|≥ 2.13.3                  |Fully compatible|
|≥ 2.12.8                  |Fully compatible|
|1.X                       |Not compatible|

#### Features / Enhancements

- **Data**: Limit memory consumption when using Datamart (a JDBC setting fix enables and end to end streaming)
- **Data**: Some SQL Queries for Datamart Extraction has been recoded to limit use of JOIN clauses for a better efficiency. 

Below a sample of extractions for a huge database (41551  snapshots, 2 billions of rows in DSS_METRIC_RESULTS):

| **REST API Memory settings**         | **Extraction Restriction**                                                               | **Extraction Time (transform & load time is not included)** |
|-------------------------------------|-------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| -**Xmx2048m** -Xms512m              | SET EXTRACT_SNAPSHOTS_MONTHS=4<br>set EXTRACT_MOD=OFF<br>set EXTRACT_TECHNO=OFF           | 12 min                                                      |
| -**Xmx2048m** -Xms512m              | SET EXTRACT_SNAPSHOTS_MONTHS=4                                                            | 2h 30min                                                    |
| -**Xmx2048m** -Xms512m              | SET EXTRACT_SNAPSHOTS_MONTHS=6                                                            | 3h 24min                                                    |
| -**Xmx2048m** -Xms512m              | N/A                                                                                       | 7h 40min                                                    |
| -**Xmx512m** -Xms512m               | SET EXTRACT_SNAPSHOTS_MONTHS=6                                                            | 3h 25min                                                    |



## Version: 2.5.4 - 28 November 2024

#### Compatibility

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|≥ 2.13.1                  |Fully compatible|
|≥ 2.12.6                  |Fully compatible|
|≥ 2.7.0                   |Compatible except the support of ```EXTRACT_SNAPSHOTS_MONTHS``` environment variable
|1.X                       |Not compatible|

#### Features / Enhancements

- **Scripts**: Add the ```EXTRACT_SNAPSHOTS_MONTHS``` environment variable, in order to limit the extraction of snapshots up to X months.
- **Data**: Limit memory consumption when using Datamart 
- **Data**: Optimization of some queries for data extraction of ```APP_SCORES, APP_TECHNO_SCORES, MOD_SCORES, MOD_TECHNO_SCORES``` tables.

## Version: 2.5.3 - 27 June 2022

#### Compatibility

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|≥ 2.7.0                   |Fully compatible|
|≥ 2.6.3                   |Prerequisite: Replace the Datamart JAR file of the ```WEB-INF\lib``` folder of your deployed Tomcat webapp with ```cast-datamart-2.5.3.jar``` file from the ```lib``` folder of this Datamart distribution.|
|1.X                       |Not compatible|

#### Bug Fixes

- **Data**: REST API 2.7.0: Set a strict order of extracted rows for XXX_VIOLATIONS_EVOLUTION table, in order to skip duplicated rows.

## Version: 2.5.2 - 14 June 2022

#### Compatibility

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|≥ 2.6.3                   |Fully compatible|
|1.X                       |Not compatible|

#### Features / Enhancements

- **Scripts**: Add the ```EXTRACT_ZERO_WEIGHT``` environment variable, in order to extract also Zero Weight Rules and Results. Note: this variable is for a specific customer context, as Zero Weights Rules are not pushed to the measurement base for latest AIP releases.

## Version: 2.5.1 - 1 June 2022

#### Compatibility

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|≥ 2.6.2                   |Fully compatible|
|≥ 2.5.1 (Tomcat)          |Prerequisite: Replace the Datamart JAR file of the ```WEB-INF\lib``` folder of your deployed Tomcat webapp with ```cast-datamart-2.5.1.jar``` file from the ```lib``` folder of this Datamart distribution.|
|1.X                       |Not compatible|

#### Bug Fixes

- **Data**: Even when the latest snapshot of an application is a malformed snapshot, rules of this application must be extracted into DIM_RULES table.

## Version: 2.4.0 - 14 February 2022

#### Compatibility

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|≥ 2.5.2                   |Fully compatible|
|= 2.5.1                   |Fully compatible (but technical debt limited to 2,147,483,647)
|≥ 2.4.X (Tomcat)          |Prerequisite: Replace the Datamart JAR file of the ```WEB-INF\lib``` folder of your deployed Tomcat webapp with ```cast-datamart-2.4.0.jar``` file from the ```lib``` folder of this Datamart distribution.|
|≥ 2.4.X (Zip File)        |Not compatible|
|≤ 2.3.X                   |Not compatible|
|1.X                       |Not compatible|

#### Upgrade

The Datamart schema has been changed, you may need to upgrade the datamart schema: see [Schema Upgrade](README.md#Schema-Upgrade).

#### Features / Enhancements

- **Data**: Change column type from INT to BIGINT:
    - Tables ```APP_HEALTH_SCORES```, ```MOD_HEALTH_SCORES```, View ```APP_ISO_SCORES_VIEW```
      - Column ```OMG_TECHNICAL_DEBT```
    - Tables ```APP_HEALTH_EVOLUTION```, ```MOD_HEALTH_EVOLUTION```
      - Column ```OMG_TECHNICAL_DEBT_ADDED```
      - Column ```OMG_TECHNICAL_DEBT_DELETED```

## Version: 2.3.1 - 27 January 2022

#### Compatibility

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|= 2.5.1                   |Fully compatible|
|≥ 2.4.X (Tomcat)          |Prerequisite: Replace the Datamart JAR file of the ```WEB-INF\lib``` folder of your deployed Tomcat webapp with ```cast-datamart-2.3.1.jar``` file from the ```lib``` folder of this Datamart distribution.|
|≥ 2.4.X (Zip File)        |Not compatible|
|≤ 2.3.X                   |Not compatible|
|1.X                       |Not compatible|

#### Upgrade

The Datamart schema has been extended, you may need to upgrade the datamart schema: see [Schema Upgrade](README.md#Schema-Upgrade)
PostgreSQL version 9.6 or higher is a new prerequisite.

- **Data**: Add extracted column
    - Tables ```APP_HEALTH_SCORES```, ```MOD_HEALTH_SCORES```, View ```APP_ISO_SCORES_VIEW```
      - Column ```OMG_TECHNICAL_DEBT```
    - Tables ```APP_HEALTH_EVOLUTION```, ```MOD_HEALTH_EVOLUTION```
      - Column ```OMG_TECHNICAL_DEBT_ADDED```
      - Column ```OMG_TECHNICAL_DEBT_DELETED```

#### Features / Enhancements

- **Data**: Add extracted column
    - Tables ```APP_HEALTH_SCORES```, ```MOD_HEALTH_SCORES```, View ```APP_ISO_SCORES_VIEW```
      - Column ```OMG_TECHNICAL_DEBT```
    - Tables ```APP_HEALTH_EVOLUTION```, ```MOD_HEALTH_EVOLUTION```
      - Column ```OMG_TECHNICAL_DEBT_ADDED```
      - Column ```OMG_TECHNICAL_DEBT_DELETED```      

- **Data**: Add columns (OMG Technical Debt) to ```APP_ISO_SCORES_VIEW``` View
    - Column ```ISO_INDEX_TECHNICAL_DEBT```
    - Column ```ISO_SECURITY_TECHNICAL_DEBT``` 
    - Column ```ISO_RELIABILITY_TECHNICAL_DEBT```
    - Column ```ISO_PERFORMANCE_TECHNICAL_DEBT``` 
    - Column ```ISO_MAINTAINABILITY_TECHNICAL_DEBT``` 
    
- **Data**: Add columns (OMG Technical debt) to ```DATAPOND_BASEDATA``` View
    - Column ```ATDM_DEBT```
    - Column ```ATDM_DEBT_ADDED```
    - Column ```ATDM_DEBT_DELETED```        

- **Scripts**: Automatically load descriptions of Datamart tables and columns

**WARNING**: the columns for the OMG Technical Debt cannot exceed a value of 2,147,483,647 minutes which is 4,473,924 work days.

#### Bug Fixes

- **Scripts**: Fix column name for ```load_data_dictionary.bat``` script
- **Scripts**: Scripts: Add new columns for DIM_APPLICATIONS/DATAPOND_ORGANIZATION table when application tags have been added

## Version: 2.2.0 - 10 January 2022

- REST API 1.X is not supported
- REST API 2.X >= **2.5.0**
- REST API 2.4.X prior versions deployed with Tomcat, you must replace cast-datamart-X.Y.Z.jar with **cast-datamart-2.2.0.jar**

#### Upgrade

The Datamart schema has been extended. If you want to preserve an existing datamart schema, because you have built some SQL views on top of it, you must upgrade this schema with ```upgrade_schema``` command line, and refresh the data with ```run refresh``` or ```datamart refresh``` command line.

#### Features / Enhancements

- **Data**: Add extracted column
    - Tables ```APP_HEALTH_SCORES```, ```APP_SCORES``` , ```APP_TECHNO_SCORES```, ```MOD_HEALTH_SCORES```, ```MOD_SCORES``` , ```MOD_TECHNO_SCORES```,
      - Column ```COMPLIANCE_SCORE```
      
- **Data**: Add ```APP_ISO_SCORES_VIEW``` view     

## Version: 2.1.1 - 17 December 2021

- REST API 1.X is not supported
- REST API 2.X >= **2.4.3**
- REST API 2.4.X prior versions deployed with Tomcat, you must replace cast-datamart-X.Y.Z.jar with cast-datamart-2.1.1.jar

#### Bug Fixes

- **Data**: Avoid unknown snapshot reference for sizing measures evolution tables (APP_SIZING_EVOLUTION) when some bad snapshots have been skipped 

## Version: 2.1.0 - 9 November 2021

#### Prerequisite

- REST API 1.X is not supported
- REST API 2.X >= **2.4.0**

Starting from REST API 2.4.0, if you have deployed the Dashboards/REST API with Tomcat, you will be able to overwrite the REST API backend to update the Datamart Extractor Web Services.

#### Upgrade

The Datamart schema has been extended. If you want to preserve an existing datamart schema, because you have built some SQL views on top of it, you must upgrade this schema with ```upgrade_schema``` command line, and refresh the data with ```run refresh``` or ```datamart refresh``` command line.

#### Features / Enhancements

- **Data**: Add extracted columns
    - Tables ```APP_SIZING_MEASURES```, ```APP_TECHNO_SIZING_MEASURES``` , ```MOD_SIZING_MEASURES```, ```MOD_TECHNO_SIZING_MEASURES```:
      - Column ```NB_COMPLEXITY_VERY_HIGH```
      - Column ```NB_COMPLEXITY_HIGH```
      - Column ```NB_COMPLEXITY_MEDIUM```
      - Column ```NB_COMPLEXITY_LOW```

    - Table ```APP_SIZING_MEASURES```, ```APP_TECHNO_SIZING_MEASURES``` , ```MOD_SIZING_MEASURES```, ```MOD_TECHNO_SIZING_MEASURES```:<br>
      - Column ```NB_CYCLOMATIC_VERY_HIGH```
      - Column ```NB_CYCLOMATIC_HIGH```
      - Column ```NB_CYCLOMATIC_MEDIUM```,
      - Colmun ```NB_CYCLOMATIC_LOW```
  
#### Bug Fixes

- **Scripts**: Allow space characters in the installation (or root) folder name

## Version: 1.22.2 - 20 January 2022

#### Prerequisite

- REST API 1.X >= **1.28.0** (**1.28.9** recommended)
- REST API 2.X >= **2.2.1**
- PostgreSQL version 9.6 or higher is a new prerequisite.

#### Bug Fixes

- **Scripts**: Scripts: Add new columns for DIM_APPLICATIONS table when application tags have been added
- **Data**: REST API 1.28.8: Even when the latest snapshot of an application is a malformed snapshot, rules of this application must be extracted into DIM_RULES table.
- **Data**: REST API 1.28.9: Set a strict order of extracted rows for XXX_VIOLATIONS_EVOLUTION table, in order to skip duplicated rows.
  
## Version: 1.22.1 - 12 October 2021

#### Prerequisite

- REST API 1.X >= **1.28.0**
- REST API 2.X >= **2.2.1**

#### Bug Fixes

- **Scripts**: Add ```APIUSER``` environment variable for REST API 2.X
- **Scripts**: Fix error messages, and stop immediately in case of bad settings of environment variables

## Version: 1.22.0 - 29 September 2021

#### Prerequisite

- REST API 1.X >= **1.28.0**
- REST API 2.X >= **2.2.1**

#### Upgrade

The Datamart schema has been extended. If you want to preserve an existing datamart schema, because you have built some SQL views on top of it, you must upgrade this schema with ```upgrade_schema``` command line, and refresh the data with ```run refresh``` or ```datamart refresh``` command line.

#### Features / Enhancements

- **Scripts**: Support multiple Dashboards/REST API servers hosting the engineering domains

- **Scripts**: Reset logs before a run

- **Scripts**: Add environment variables to tune the extraction scope for better performance
    - Variable ```EXTRACT_DATAPOND```
    - Variable ```EXTRACT_MOD```
    - Variable ```EXTRACT_TECHNO```
    - Variable ```EXTRACT_SRC```
    - Variable ```EXTRACT_USR```

- **Scripts**: Add ```DEBUG``` environment variable to inspect ```extract``` and ```transform``` folders after a run.

- **Scripts**: Add DATAPOND views
    - View ```DATAPOND_BASEDATA```
    - View ```DATAPOND_VIOLATIONS```
    - View ```DATAPOND_AP```
    - View ```DATAPOND_EXCLUSIONS```
    
- **Scripts**: Add ```load_data_dictionary.bat``` script to load definitions of tables and columns.    

- **Data**: Add extracted columns
    - Table ```DIM_SNAPSHOTS```: Columns ```INTERNAL_ID```, ```CONSOLIDATION_MODE```
    - Table ```DIM_RULES```: Columns ```BUSINESS_CRITERION_ID```, ```BUSINESS_CRITERION_NAME```, ```TECHNICAL_CRITERION_WEIGHT``` , ```TECHNICAL_CRITERION_ID```
    - Table ```USR_ACTION_PLAN```: Columns ```METRIC_ID```, ```OBJECT_FULL_NAME```
    - Table ```USR_EXCLUSIONS```: Columns ```METRIC_ID```, ```OBJECT_FULL_NAME```, ```LAST_UPDATE_DATE```, ```EXCLUSION_DATE```, ```EXCLUSION_SNAPSHOT_ID```

- **Data**: Add extracted tables
    - Table ```APP_FINDINGS_MEASURES```
    - Table ```APP_TECHNO_SCORES```    
    - Table ```APP_TECHNO_SIZING_EVOLUTION```
    - Table ```APP_TECHNO_SIZING_MEASURES```
    - Table ```MOD_TECHNO_SCORES```        
    - Table ```MOD_TECHNO_SIZING_EVOLUTION```
    - Table ```MOD_TECHNO_SIZING_MEASURES```

#### Bug Fixes

- **Data**: Skip detached metrics for most tables (including USR_ACTION_PLAN)

## Version: 1.21.0 - 7 July 2021

#### Prerequisite

- REST API  >= **1.17** (**1.27** recommended)

#### Features / Enhancements

- **Scripts**: An error is raised if two applications are given the same name

#### Bug Fixes

- **Data**: REST API 1.27.0, 2.1.0 - Fix a SQL sort so that the "transform" step can discover duplicated rows for MOD_HEALTH_SCORES table, without stopping in error
- **Scripts**: On windows 10, remove the precedence of ```C:\windows\system32\curl.exe``` on the third-party directory for ```curl```

## Version: 1.20.0 - 19 March 2021

#### Prerequisite

- REST API  >= **1.17**, >= **1.25** (recommended)


#### Features / Enhancements

- **Data**: REST API 1.25.0 - Extraction optimization of ```APP_VIOLATIONS_MEASURES``` table
- **Data**: REST API 1.25.0 - Extraction optimization of ```MOD_VIOLATIONS_MEASURES``` table
- **Scripts**: The "transform" step of ETL scripts skips lines with duplicated keys values, and reports these lines in the output. The ETL scripts are more robust whatever the REST API release.

#### Bug Fixes

- **Data**: REST API 1.25.0 - Skip some zombie applications
- **Scripts**: Remove the ```cookies.txt``` file at the end of the extraction

## Version: 1.19.3 - 9 November 2020

#### Prerequisite

- REST API  >= **1.17**, >= **1.24** (recommended)


#### Features / Enhancements

- **Data**: REST API 1.24.0 - Extraction optimization of ```APP_VIOLATIONS_MEASURES``` table
- **Data**: REST API 1.24.0 - Extraction optimization of ```APP_SIZING_MEASURES``` table
- **Data**: REST API 1.24.0 - Extraction optimization of ```MOD_VIOLATIONS_MEASURES``` table
- **Data**: REST API 1.24.0 - Extraction optimization of ```MOD_SIZING_MEASURES``` table
- **Data**: REST API 1.24.0 - Filter duplicated rows of ```STD_RULES``` table
- **Data**: REST API 1.23.0 - Filter zero weights and null grades

#### Bug Fixes

- **Data**: REST API 1.23.1 - Some results of ```APP_HEALTH_EVOLUTION``` must be skipped because the metrics are no more attached
- **Data**: REST API 1.23.1 - Filter duplicated rows in ```DSS_METRIC_RESULTS``` 
- **Data**: REST API 1.23.1 - The snapshot string timestamp may be incorrect because of a JDK bug of SimpleDateFormat.format for a specific date and a specific time zone
- **Data**: REST API 1.23.0 - When a quality rule has been detached, it should not be extracted into ```SRC_VIOLATIONS``` 
- **Data**: REST API 1.22.0 - When a quality index extension (ex: CISQ Index) is installed, REST API must filter these technical criteria for ```DIM_RULES``` table
- **Scripts**: ```datamart update``` code review, and tests

## Version: 1.19.2 - 18 September 2020

#### Prerequisite

- REST API  >= **1.17**, >= **1.19** (recommended)


#### Bug Fixes

- **Scripts**: ```LOG_FILE``` variable is missing in ```create_views.bat``` and ```create_datapond_views.bat``` scripts

## Version: 1.19.1 - 14 September 2020

#### Prerequisite

- REST API  >= **1.17**, >= **1.19** (recommended)


#### Bug Fixes

- **Scripts**: Accept uppercase characters for the ```_DB_SCHEMA``` variable of ```setenv.bat``` file
- **Scripts**: When running datamart.bat command line, the write access on temporary file ```DOMAINS.TXT``` is checked
- **Scripts**: When running datamart.bat command line, the standard output must be redirected for AAD domain extraction. 
- **Scripts**: When running datamart.bat command line, the list of domains should not be empty when distinct WARs are used for Engineering Dashboard and Health Dashboard
- **Scripts**: When running datamart.bat command line, on Windows Server operating system, a redirection of standard output should work as on Windows 10.

#### Features / Enhancements

- **Scripts**: The number of Tomcat user sessions created during the extraction has been dramatically reduced.


## Version: 1.19.0 - 6 August 2020

#### Prerequisite

- REST API  >= **1.17**, >= **1.19** (recommended)


#### Bug Fixes

- **Data**: REST API 1.19 supports some irregular data (duplicated rows, unexpected extra rows, bad application object)
- **Scripts**: The loop of extraction can iterate over 400 applications for ```datamart.bat``` command line

#### Features / Enhancements

- **Scripts**: There is no more a single log file for a run. We set a log file for each domain with no rotation.
- **Scripts**: The ```datamart.bat``` command line saves the stdout/stderr of each transferred domain in the ```log``` directory
- **Scripts**: The ```JOBS ``` environment variable has been added to transfer data with concurrent jobs for ```datamart.bat``` command line
- **Scripts**: The extract/transform files are removed after each domain load success.

## Version: 1.17.0 - 8 May 2020

#### Prerequisite

- REST API **1.17** or **1.18**<br>


#### Features / Enhancements

- **Data**: Add ```DIM_OMG_RULES``` to filter rules according to OMG-ASCQM Index extension
- **Data**: Add ```DIM_CISQ_RULES``` to filter rules according to CISQ Index extension
- **Performance**: Optimize ```SRC_TRX_OBJECTS``` table extraction to fetch 55 millions of rows in 6 minutes (Intel Xeon CPU 3,5 GHz, 16 Gb RAM), and without ```GC overhead limit exceeded``` message
- **Output Format**: Set the  comma character as a CSV delimiter so that CSV extracted files can be more easily loaded into Excel
 
#### Bug Fixes

- **Data**: Skip inconsistent snapshots (REST API 1.18)
- **Data**: ```STD_DESCRIPTIONS``` is not extracted if the Measurement base version is lower than 8.3.10 (REST API 1.18)
- **Data**: Fix ```DIM_RULES``` table extraction, 'critical' flags were not correct in case of change between the 2 last snapshots

## Version: 1.16.3 - May 2020

#### Features / Enhancements

- **Scripts**: Adapt scripts with renewed ```thirdparty``` content tested on Windows 7 and Windows 10
  - PostgreSQL 10.12 client
  - Curl 7.70

## Version: 1.16.2 - May 2020

#### Features / Enhancements

- **Scripts**: The third party binaries (Python, Curl, PGSQL) can be embedded in a ```thirdparty``` folder. This folder is distributed in the datamart package downloaded from ```extendng.castsoftware.com``` web site.

## Version: 1.16.1 BETA - May 2020

#### Bug Fixes

- **Scripts**: Fix support encoded PostgreSQL password for ```datamart.bat``` command line
- **Scripts**: Fix README, remove the storage of sensitive information in configuration files

## Version: 1.16.0 BETA - March 2020

#### Prerequisite

- REST API **1.16**<br>
- AIP Database > **8.3.5**
- Python > **3.6.4**

#### Features / Enhancements

- **Scripts**: Check python version is higher than **3.6.4**

#### Bug Fixes
 
 - **Data**: Fix ```SRC_VIOLATIONS``` table extraction, some violations were skipped, and some findings names were not correct.
 - **Data**: Fix ```ACTION_STATUS``` column of ```USR_ACTION_PLAN``` table. 

## Version: 1.15.0 BETA - February 2020

#### Prerequisite

- REST API **1.15**<br>
Note: This new version of the REST API limits memory consumption when fetching a large set of data from database.
- AIP Database > **8.3.5**
- Python > **3.6.4**

#### Upgrade

- You must replicate your variables settings from the previous ```setenv.bat``` into the new one. Replace all the other scripts and files, do not attempt a partial update
- Make sure that you do not set double-quotes around the ```PGPASSWORD``` and ```CREDENTIALS``` values, using the ```^```character, you can also  obfuscate these values to avoid the command evaluation (see README.md)
- You may want to preserve an existing datamart schema, because you have built some SQL views on top of it. In this case you must upgrade this schema with ```upgrade_schema``` command line, and refresh the data with ```run refresh``` or ```datamart update``` command line

#### Features / Enhancements

- **Data**: Add ```SRC_TRX_HEALTH_IMPACTS``` table to store transaction risk indexes
- **Data**: Add ```VERSION``` column to ```DIM_SNAPSHOTS``` table
- **Data**: Add ```NB_VIOLATIONS```, ```NB_VIOLATED_RULES```, ```SNAPSHOT_ID``` columns to ```SRC_HEALTH_IMPACTS``` table
- **Scripts**: Add HTTP header ```X-Client: Datamart``` so that the Datamart requests are identified in the REST API audit trail
- **Scripts**: Move environment variables checking from ```setenv.bat``` to ```checkenv.bat```
- **Scripts**: Remove ```INSTALLATION_FOLDER``` environment variable from ```setenv.bat```
- **Scripts**: Check paths validity for input environment variables in ```setenv.bat```
- **Scripts**: Allow scripts call from any directory (i.e. the current working directory is not necessarily the location of the scripts)
- **Scripts**: Display a possible cause on REST API common errors
- **Scripts**: Add ```APIKEY``` as an alternative authentication to the REST API
- **Scripts**: Add ```--retry 5``` option when requesting data with ```curl```, in case of network errors
- **Scripts**: Move creation of datapond views to ```create_datapond_views.bat``` script ; `create_views.bat` script creates optional views
- **Scripts**: Ability to obfuscate the ```CREDENTIALS```, ```PGPASWORD```, ```APIKEY``` environment variables to prevent "shoulder surfing"
- **Scripts**: Add a directory ```log``` for log files
- **Scripts**: Rename ```ETL.log``` by adding a time-stamp in the file name. Ex: ```ETL-2020-03-03T11-04-12.log```
 
#### Bug Fixes

- **Data**: Fix ```TECHNOLOGY``` column for ```SRC_OBJECTS``` table: replace the 'All' identifier with the effective technology name

## Version: 1.14.0 BETA - January 2020

First release.

#### Prerequisite

- REST API  **1.14**



