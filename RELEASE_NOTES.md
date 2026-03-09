## Version: 3.0.2-linux - 6 March 2026

|Imaging Console Release   |Compatibility   |
|--------------------------|----------------|
|≥ 3.5.0 (Windows)         |Fully compatible|
|≥ 3.5.0 (Linux)           |Not compatible, use the Docker version of the Datamart|

|Dashboard REST API Release|Compatibility|
|--------------------------|-------------|
|≥ 2.13.2                  |Prerequisite: Replace the Datamart JAR file of the ```WEB-INF\lib``` folder of your deployed Tomcat webapp with ```cast-datamart-3.0.2.jar``` file from the ```lib``` folder of this Datamart distribution.|
|≥ 2.12.9                  |Fully compatible|
|2.12.8                    |Prerequisite: Replace the Datamart JAR file of the ```WEB-INF\lib``` folder of your deployed Tomcat webapp with ```cast-datamart-3.0.2.jar``` file from the ```lib``` folder of this Datamart distribution.|
|1.X                       |Not compatible|

#### Features / Enhancements

- **Scripts**: Enhance PSQL log with a timestamp and more detailed traces

## Version: 3.0.1-linux - 4 March 2026

#### Compatibility
 
|Imaging Console Release   |Compatibility   |
|--------------------------|----------------|
|≥ 3.5.0 (Linux)           |Fully compatible|
|≥ 3.5.0 (Windows)         |Not compatible, use the Windows version of the Datamart| 

#### Bug Fixes

- **Scripts**: CSV contents are read with UTF-8 encoding by default, force parameter ```newline=""``` when reading CSV.

## Version: 3.0.0-linux - 26 November 2025

#### Compatibility

|Imaging Console Release   |Compatibility   |
|--------------------------|----------------|
|≥ 3.5.0 (Linux)           |Fully compatible|
|≥ 3.5.0 (Windows)         |Not compatible, use the Windows version of the Datamart| 

