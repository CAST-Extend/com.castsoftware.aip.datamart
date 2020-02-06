# Branch: next-release
 - Add VERSION column for DIM_SNAPSHOTS table

# Branch: master
 - Add ```--retry 5``` in ```utilities\curl-bat.bat``` script to retry extraction in case of network errors
 - Add explicit command ```python``` to run the ```transform.py``` script in ```transform.bat``` file ; otherwise the 'transform' step may be skipped, and the 'load' step fails
 - Add a directory ```log``` for log files
 - Rename ```ETL.log``` by adding a timestamp in the file name. Ex: ```ETL-04-Feb-20-13-40-00.32.log```
 
# Branch: 1.14.BETA
First version