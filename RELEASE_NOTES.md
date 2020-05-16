## Branch: 1.17.0 - 8 May 2020

#### Prerequisite

- REST API **1.17**<br>
- AIP Database > 8.3.5
- Python > **3.6.4**

#### Features / Enhancements

 - _Data_: Add ```DIM_OMG_RULES``` to filter rules according to OMG-ASCQM Index extension
 - _Data_: Add ```DIM_CISQ_RULES``` to filter rules according to CISQ Index extension
 - _Performance_: Optimize ```SRC_TRX_OBJECTS``` table extraction to fetch 55 millions of rows in 6 minutes (Intel Xeon CPU 3,5 GHz, 16 Gb RAM), and without ```GC overhead limit exceeded``` message
 - _Output Format_: Set the  comma character as a CSV delimiter so that CSV extracted files can be more easily loaded into Excel
 
#### Bug Fixes
 - _Data_: Fix ```DIM_RULES``` table extraction, 'critical' flags were not correct in case of change between the 2 last snapshots

## Branch: 1.16.3 - May 2020

#### Features / Enhancements

- _Scripts_: Adapt scripts with renewed ```thirdparty``` content tested on Windows 7 and Windows 10
  - PostgreSQL 10.12 client
  - Curl 7.70

## Branch: 1.16.2 - May 2020

#### Features / Enhancements

- _Scripts_: The third party binaries (Python, Curl, PGSQL) can be embedded in a ```thirdparty``` folder. This folder is distributed in the datamart package downloaded from ```extendng.castsoftware.com``` web site.

## Branch: 1.16.1 BETA - May 2020

#### Bug Fixes

- _Scripts_: Fix support encoded PostgreSQL password for ```datamart.bat``` command line
- _Scripts_: Fix README, remove the storage of sensitive information in configuration files

## Branch: 1.16.0 BETA - March 2020

#### Prerequisite

- REST API **1.16**<br>
- AIP Database > **8.3.5**
- Python > **3.6.4**

#### Features / Enhancements

- _Scripts_: Check python version is higher than **3.6.4**

#### Bug Fixes
 
 - _Data_: Fix ```SRC_VIOLATIONS``` table extraction, some violations were skipped, and some findings names were not correct.
 - _Data_: Fix ```ACTION_STATUS``` column of ```USR_ACTION_PLAN``` table. 

## Branch: 1.15.0 BETA - February 2020

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

- _Data_: Add ```SRC_TRX_HEALTH_IMPACTS``` table to store transaction risk indexes
- _Data_: Add ```VERSION``` column to ```DIM_SNAPSHOTS``` table
- _Data_: Add ```NB_VIOLATIONS```, ```NB_VIOLATED_RULES```, ```SNAPSHOT_ID``` columns to ```SRC_HEALTH_IMPACTS``` table
- _Scripts_: Add HTTP header ```X-Client: Datamart``` so that the Datamart requests are identified in the REST API audit trail
- _Scripts_: Move environment variables checking from ```setenv.bat``` to ```checkenv.bat```
- _Scripts_: Remove ```INSTALLATION_FOLDER``` environment variable from ```setenv.bat```
- _Scripts_: Check paths validity for input environment variables in ```setenv.bat```
- _Scripts_: Allow scripts call from any directory (i.e. the current working directory is not necessarily the location of the scripts)
- _Scripts_: Display a possible cause on REST API common errors
- _Scripts_: Add ```APIKEY``` as an alternative authentication to the REST API
- _Scripts_: Add ```--retry 5``` option when requesting data with ```curl```, in case of network errors
- _Scripts_: Move creation of datapond views to ```create_datapond_views.bat``` script ; `create_views.bat` script creates optional views
- _Scripts_: Ability to obfuscate the ```CREDENTIALS```, ```PGPASWORD```, ```APIKEY``` environment variables to prevent "shoulder surfing"
- _Scripts_: Add a directory ```log``` for log files
- _Scripts_: Rename ```ETL.log``` by adding a time-stamp in the file name. Ex: ```ETL-2020-03-03T11-04-12.log```
 
#### Bug Fixes

- _Data_: Fix ```TECHNOLOGY``` column for ```SRC_OBJECTS``` table: replace the 'All' identifier with the effective technology name

## Branch: 1.14.0 BETA - January 2020

First release.

#### Prerequisite

- REST API  **1.14**
- AIP Database > 8.3.5


