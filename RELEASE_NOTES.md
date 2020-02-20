## Branch: master - February 2020

#### Prerequisite

- REST API **1.15**<br>
Note: This new version of the REST API limits memory consumption when fetching a large set of data from database.
- AIP Database > 8.3.5

#### Upgrade

- You must replicate your variables settings from the previous ```setenv.bat``` into the new one. Replace all the other scripts and files, do not attempt a partial update
- Make sure that you do not set double-quotes around the ```PGPASSWORD``` and ```CREDENTIALS``` values, using the ```^```character, you can also  obfuscate these values to avoid the command evaluation (see README.md)
- You may want to preserve an existing datamart schema, because you have built some SQL views on top of it. In this case you must upgrade this schema with ```upgrade_schema``` command line, and refresh the data with ```run refresh``` or ```datamart update``` command line.

#### What's new?

##### Data
 - Fix ```TECHNOLOGY``` column for ```SRC_OBJECTS``` table: replace the 'All' identifier with the effective technology name
 - Add ```SRC_TRX_HEALTH_IMPACTS``` table to store transaction risk indexes
 - Add ```VERSION``` column to ```DIM_SNAPSHOTS``` table
 - Add ```NB_VIOLATIONS```, ```NB_VIOLATED_RULES```, ```SNAPSHOT_ID``` columns to ```SRC_HEALTH_IMPACTS``` table
 
##### Scripts
 - Add ```APIKEY``` to authenticate to the REST API
 - Move environment variables checking from ```setenv.bat``` to ```checkenv.bat```
 - Check paths validity for input environment variables in ```setenv.bat```
 - Add ```--retry 5``` option when requesting data with ```curl```, in case of network errors
 - Move creation of datapond views to ```create_datapond_views.bat``` script ; `create_views.bat` script creates optional views,
 - Ability to obfuscate the ```CREDENTIALS```, ```PGPASWORD```, ```APIKEY``` environment variables to prevent "shoulder surfing".
 - Add a directory ```log``` for log files
 - Rename ```ETL.log``` by adding a time-stamp in the file name. Ex: ```ETL-04-Feb-20-13-40-00.32.log```
 
## Branch: 1.14.BETA - January 2020

First release.

#### Prerequisite

- REST API  **1.14**
- AIP Database > 8.3.5

