
## Branch: next-release

#### Prerequisite

- REST API **1.15**<br>

#### Upgrade

If you have built a datamart schema with a prior version of the REST API, then you must upgrade this schema with ```upgrade_schema``` command line, and refresh the data with ```run refresh``` or ```datamart update``` command line.

#### Resolved issues
 - Fix TECHNOLOGY column for SRC_OBJECTS table: replace the 'All' idenfifier with the effective technology name

#### Updates 
 - Add SRC_TRX_HEALTH_IMPACTS table to store transaction risk indexes
 - Add VERSION column for DIM_SNAPSHOTS table
 - `create_views.bat` script create optional views, Datapond views are created with `create_datapond_views.bat`
 
## Branch: master

#### Prerequisite

- REST API: 1.14

#### Resolved issues
 - Add ```--retry 5``` in ```utilities\curl-bat.bat``` script to retry extraction in case of network errors
 - Add explicit command ```python``` to run the ```transform.py``` script in ```transform.bat``` file ; otherwise the 'transform' step may be skipped, and the 'load' step fails
 
#### Updates 
 - Add a directory ```log``` for log files
 - Rename ```ETL.log``` by adding a timestamp in the file name. Ex: ```ETL-04-Feb-20-13-40-00.32.log```
 
## Branch: 1.14.BETA

First version

#### Prerequisite

- REST API  **1.14**

