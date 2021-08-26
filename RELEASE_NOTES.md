## Version: 1.22.0 - 26 August 2021

- REST API  **1.28**, **2.2.0**
- AIP Database > 8.3.5

#### Features / Enhancements

- **Scripts**: Add ```DATAPOND_BASEDATA``` view
- **Scripts**: Add ```DATAPOND_VIOLATIONS``` view
- **Scripts**: When the environment variable ```DATAPOND``` is set to ```ON```, then the ```DIM_APPLICATIONS``` table is renamed as ```DATAPOND_ORGANIZATION``` and columns are renamed to comply with DATAPOND toolkit
- **Data**: Add ```INTERNAL_ID``` and ```CONSOLIDATION_MODE``` columns to ```DIM_SNAPSHOTS``` table
- **Data**: Add ```BUSINESS_CRITERION_ID```, ```BUSINESS_CRITERION_NAME```, ```TECHNICAL_CRITERION_WEIGHT``` , ```TECHNICAL_CRITERION_ID``` columns to ```DIM_RULES``` table
- **Data**: Add ```APP_VIOLATIONS_EVOLUTION``` table
- **Data**: Add ```MOD_VIOLATIONS_EVOLUTION``` table
- **Data**: Add ```APP_TECHNO_SIZING_MEASURES``` table
- **Data**: Add ```MOD_TECHNO_SIZING_MEASURES``` table
- **Data**: Add ```APP_TECHNO_SIZING_EVOLUTION``` table
- **Data**: Add ```MOD_TECHNO_SIZING_EVOLUTION``` table

#### Bug Fixes

- **DATA**: Skip detached metrics for most tables (including USR_ACTION_PLAN)

## Version: 1.21.0 - 7 July 2021

- REST API  >= **1.17** (**1.27** recommended), WARNING: **2.X** should not be used for Datamart
- AIP Database > 8.3.5

#### Features / Enhancements

- **Scripts**: An error is raised if two applications are given the same name

#### Bug Fixes

- **Data**: REST API 1.27.0, 2.1.0 - Fix a SQL sort so that the "transform" step can discover duplicated rows for MOD_HEALTH_SCORES table, without stopping in error
- **Scripts**: On windows 10, remove the precedence of ```C:\windows\system32\curl.exe``` on the third-party directory for ```curl```

## Version: 1.20.0 - 19 March 2021

#### Prerequisite

- REST API  >= **1.17**, >= **1.25** (recommended)
- AIP Database > 8.3.5

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
- AIP Database > 8.3.5

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
- AIP Database > 8.3.5

#### Bug Fixes

- **Scripts**: ```LOG_FILE``` variable is missing in ```create_views.bat``` and ```create_datapond_views.bat``` scripts

## Version: 1.19.1 - 14 September 2020

#### Prerequisite

- REST API  >= **1.17**, >= **1.19** (recommended)
- AIP Database > 8.3.5

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
- AIP Database > 8.3.5

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
- AIP Database > 8.3.5

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
- AIP Database > 8.3.5


