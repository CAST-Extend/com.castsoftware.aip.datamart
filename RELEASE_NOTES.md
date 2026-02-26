## Version: 3.0.1-linux - 25 February 2026

#### Compatibility

If the Dashboard REST API backend is running on Windows with a version prior to ```3.6.0```, then the ```CSV_ENCODING``` environment variable may be required to declare the codepage host of the JVM backend if ever the JVM default code page has not been forced to UTF-8.

This codepage name is a python charset. You can get the list with:
```
import encodings
encodings.aliases.aliases.values())
```

For example, in ```.env``` file, you can set the variable as follow, to declare a JVM bakend running with a code cage for Americas or Western Europe:
```
CSV_ENCODING=cp1252
```
 
|Imaging Console Release   |Compatibility   |
|--------------------------|----------------|
|≥ 3.3.0                   |Fully compatible.|

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|≥ 2.13.2                  |Prerequisite: Replace the Datamart JAR file of the ```WEB-INF\lib``` folder of your deployed Tomcat webapp with ```cast-datamart-3.0.0.jar``` file from the ```lib``` folder of this Datamart distribution.|
|≥ 2.12.8                  |Fully compatible|
|1.X                       |Not compatible|

#### Bug Fixes

- **Script**: Force decoding the extracted CSV content with the charset set with the ```CSV_ENCODING``` environment variable if it is defined, otherwise assume the content is ```UTF-8```.

## Version: 3.0.0-linux - 26 November 2025

#### Compatibility

|Imaging Console Release   |Compatibility   |
|--------------------------|----------------|
|≥ 3.3.0                   |Fully compatible|

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|≥ 2.13.2                  |Prerequisite: Replace the Datamart JAR file of the ```WEB-INF\lib``` folder of your deployed Tomcat webapp with ```cast-datamart-3.0.0.jar``` file from the ```lib``` folder of this Datamart distribution.|
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

