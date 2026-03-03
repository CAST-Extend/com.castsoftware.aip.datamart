## Version: 3.0.1-linux - (Not yet released)

#### Compatibility
 
|Imaging Console Release   |Compatibility   |
|--------------------------|----------------|
|≥ 3.6.0 (Linux)           |Fully compatible|
|≥ 3.6.0 (Linux)           |Fully compatible|

#### Bug Fixes

- **Scripts**: CSV contents are read with UTF-8 encoding by default.

## Version: 3.0.0-linux - 26 November 2025

#### Compatibility

|Imaging Console Release   |Compatibility   |
|--------------------------|----------------|
|≥ 3.3.0 (Linux)           |Fully compatible|
|≥ 3.3.0 (Windows)         |Not compatible, use the Windows version of the Datamart| 

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

