## Branch: master

#### Prerequisite

- REST API **1.15**<br>
Note: This new version of the REST API limits memory consumption when fetching a large set of data from database.

#### Upgrade

- You must replicate your variables settings from the previous ```setenv.bat``` into the new one. Replace all the other scripts and files, do not attempt a partial update
- Make sure that you do not set double-quotes around the ```PGPASSWORD``` and ```CREDENTIALS``` variables, using the ```^```character, you can also  obfuscate these variable to avoid the command evaluation (see README.md)
- You may want to preserve an existing datamart schema, because you have built some SQL views on top of it. In this case you must upgrade this schema with ```upgrade_schema``` command line, and refresh the data with ```run refresh``` or ```datamart update``` command line.

#### What's new?

##### Data scope
 - Fix ```TECHNOLOGY``` column for ```SRC_OBJECTS``` table: replace the 'All' identifier with the effective technology name
 - Add ```SRC_TRX_HEALTH_IMPACTS``` table to store transaction risk indexes
 - Add ```VERSION``` column to ```DIM_SNAPSHOTS``` table
 - Add ```NB_VIOLATIONS```, ```NB_VIOLATED_RULES```, ```SNAPSHOT_ID``` columns to ```SRC_HEALTH_IMPACTS``` table
 
##### Scripts
 - Check paths validity for input environment variables in `setenv.bat`
 - Add ```--retry 5``` option when requesting data with ```curl```, in case of network errors
 - Add explicit command ```python``` to run the ```transform.py``` script in ```transform.bat``` file ; otherwise the 'transform' step may be skipped, and the 'load' step fails
  - `create_views.bat` script create optional views, Datapond views are created with `create_datapond_views.bat`
 - Ability to obfuscate the CREDENTIALS and the PGPASWORD environment variables to prevent "shoulder surfing".
 - Add a directory ```log``` for log files
 - Rename ```ETL.log``` by adding a time-stamp in the file name. Ex: ```ETL-04-Feb-20-13-40-00.32.log```
 
## Branch: 1.14.BETA

First version

#### Prerequisite

- REST API  **1.14**

