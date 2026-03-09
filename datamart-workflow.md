# Datamart Workflow

This workflow has been designed as a mirroring copy of the data.
The ```datamart update``` script has been added later, to minimize the time processing after a snapshot, by skipping applications with no new snapshot.

## run install
```
EXEC run install 
    EXEC extract install DEFAULT_ROOT            
        for each table of
                DIM_SNAPSHOTS
                DIM_RULES
                DIM_OMG_RULES
                DIM_CISQ_RULES
                DIM_APPLICATIONS
                APP_VIOLATIONS_MEASURES
                APP_VIOLATIONS_EVOLUTION
                APP_SIZING_MEASURES
                APP_FUNCTIONAL_SIZING_MEASURES
                APP_HEALTH_SCORES
                APP_SCORES
                APP_SIZING_EVOLUTION
                APP_FUNCTIONAL_SIZING_EVOLUTION
                APP_HEALTH_EVOLUTION
                STD_RULES
                STD_DESCRIPTIONS
                APP_TECHNO_SIZING_MEASURES
                APP_TECHNO_SCORES
                APP_TECHNO_SIZING_EVOLUTION
                MOD_VIOLATIONS_MEASURES
                MOD_VIOLATIONS_EVOLUTION
                MOD_SIZING_MEASURES
                MOD_HEALTH_SCORES
                MOD_SCORES
                MOD_SIZING_EVOLUTION
                MOD_HEALTH_EVOLUTION
                MOD_TECHNO_SIZING_MEASURES
                MOD_TECHNO_SCORES
                MOD_TECHNO_SIZING_EVOLUTION
                APP_FINDINGS_MEASURES
                USR_EXCLUSIONS
                USR_ACTION_PLAN
                SRC_OBJECTS
                SRC_TRANSACTIONS
                SRC_TRX_OBJECTS
                SRC_HEALTH_IMPACTS
                SRC_TRX_HEALTH_IMPACTS
                SRC_VIOLATIONS
                SRC_MOD_OBJECTS 
            EXEC curl rest/DEFAULT_ROOT/datamart/{table}
    EXEC transform install
    EXEC load 
        DROP TABLE IF EXISTS table CASCADE;
        CREATE TABLE table...  
        COPY...
```

## run refresh
```
EXEC run refresh 
    EXEC extract refresh DEFAULT_ROOT            
        for each table of
                DIM_SNAPSHOTS
                DIM_RULES
                DIM_OMG_RULES
                DIM_CISQ_RULES
                DIM_APPLICATIONS
                APP_VIOLATIONS_MEASURES
                APP_VIOLATIONS_EVOLUTION
                APP_SIZING_MEASURES
                APP_FUNCTIONAL_SIZING_MEASURES
                APP_HEALTH_SCORES
                APP_SCORES
                APP_SIZING_EVOLUTION
                APP_FUNCTIONAL_SIZING_EVOLUTION
                APP_HEALTH_EVOLUTION
                STD_RULES
                STD_DESCRIPTIONS
                APP_TECHNO_SIZING_MEASURES
                APP_TECHNO_SCORES
                APP_TECHNO_SIZING_EVOLUTION
                MOD_VIOLATIONS_MEASURES
                MOD_VIOLATIONS_EVOLUTION
                MOD_SIZING_MEASURES
                MOD_HEALTH_SCORES
                MOD_SCORES
                MOD_SIZING_EVOLUTION
                MOD_HEALTH_EVOLUTION
                MOD_TECHNO_SIZING_MEASURES
                MOD_TECHNO_SCORES
                MOD_TECHNO_SIZING_EVOLUTION
                APP_FINDINGS_MEASURES
                USR_EXCLUSIONS
                USR_ACTION_PLAN
                SRC_OBJECTS
                SRC_TRANSACTIONS
                SRC_TRX_OBJECTS
                SRC_HEALTH_IMPACTS
                SRC_TRX_HEALTH_IMPACTS
                SRC_VIOLATIONS
                SRC_MOD_OBJECTS 
            EXEC curl rest/DEFAULT_ROOT/datamart/{table}
    EXEC transform install
    EXEC load 
        TRUNCATE TABLE table CASCADE;
        ALTER TABLE table ADD COLUMN IF NOT EXISTS...
        COPY...
```

## datamart install
```
EXEC datamart install
    EXEC datamart.py HD-INSTALL HD_ROOT
        transfer_aad_domain("install")
            EXEC run install HD_ROOT AAD
                EXEC extract install HD_ROOT            
                    for each table of
                            DIM_SNAPSHOTS
                            DIM_RULES
                            DIM_OMG_RULES
                            DIM_CISQ_RULES
                            DIM_APPLICATIONS
                            APP_VIOLATIONS_MEASURES
                            APP_VIOLATIONS_EVOLUTION
                            APP_SIZING_MEASURES
                            APP_FUNCTIONAL_SIZING_MEASURES
                            APP_HEALTH_SCORES
                            APP_SCORES
                            APP_SIZING_EVOLUTION
                            APP_FUNCTIONAL_SIZING_EVOLUTION
                            APP_HEALTH_EVOLUTION
                            STD_RULES
                            STD_DESCRIPTIONS
                            APP_TECHNO_SIZING_MEASURES
                            APP_TECHNO_SCORES
                            APP_TECHNO_SIZING_EVOLUTION
                            MOD_VIOLATIONS_MEASURES
                            MOD_VIOLATIONS_EVOLUTION
                            MOD_SIZING_MEASURES
                            MOD_HEALTH_SCORES
                            MOD_SCORES
                            MOD_SIZING_EVOLUTION
                            MOD_HEALTH_EVOLUTION
                            MOD_TECHNO_SIZING_MEASURES
                            MOD_TECHNO_SCORES
                            MOD_TECHNO_SIZING_EVOLUTION
                            APP_FINDINGS_MEASURES
                            USR_EXCLUSIONS
                            USR_ACTION_PLAN
                            SRC_OBJECTS
                            SRC_TRANSACTIONS
                            SRC_TRX_OBJECTS
                            SRC_HEALTH_IMPACTS
                            SRC_TRX_HEALTH_IMPACTS
                            SRC_VIOLATIONS
                            SRC_MOD_OBJECTS 
                        EXEC curl rest/HD_ROOT/datamart/{table}
                EXEC transform install
                EXEC load 
                    DROP TABLE IF EXISTS table CASCADE;
                    CREATE TABLE table...  
                    COPY...
                        
        for each ed_domain
            EXEC datamart.py ED-INSTALL ED_ROOT[] DOMAINS_?.TXT
                transfer_ed_domains (ED_ROOT[], DOMAINS_?.TXT, JOBS)   
                    start_domain_transfer(ed_url, domains[pos], jobs, pos, "ed-install")  
                        EXEC run ed-install ED_ROOT[] domains[pos]   
                            EXEC extract ed-install ED_ROOT[]
                                for each table of
                                        APP_FINDINGS_MEASURES
                                        USR_EXCLUSIONS
                                        USR_ACTION_PLAN
                                        SRC_OBJECTS
                                        SRC_TRANSACTIONS
                                        SRC_TRX_OBJECTS
                                        SRC_HEALTH_IMPACTS
                                        SRC_TRX_HEALTH_IMPACTS
                                        SRC_VIOLATIONS
                                        SRC_MOD_OBJECTS  
                                    EXEC curl rest/ED_ROOT[]/datamart/{table}
                            EXEC transform ed-install
                            EXEC load 
                                TRUNCATE TABLE table CASCADE;
                                COPY...
```

## datamart refresh
```
EXEC datamart refresh
    EXEC datamart.py HD-REFRESH
        transfer_aad_domain("refresh")
            EXEC run refresh HD_ROOT AAD
                EXEC extract refresh HD_ROOT
                    for each table of
                            DIM_SNAPSHOTS
                            DIM_RULES
                            DIM_OMG_RULES
                            DIM_CISQ_RULES
                            DIM_APPLICATIONS
                            APP_VIOLATIONS_MEASURES
                            APP_VIOLATIONS_EVOLUTION
                            APP_SIZING_MEASURES
                            APP_FUNCTIONAL_SIZING_MEASURES
                            APP_HEALTH_SCORES
                            APP_SCORES
                            APP_SIZING_EVOLUTION
                            APP_FUNCTIONAL_SIZING_EVOLUTION
                            APP_HEALTH_EVOLUTION
                            STD_RULES
                            STD_DESCRIPTIONS
                            APP_TECHNO_SIZING_MEASURES
                            APP_TECHNO_SCORES
                            APP_TECHNO_SIZING_EVOLUTION
                            MOD_VIOLATIONS_MEASURES
                            MOD_VIOLATIONS_EVOLUTION
                            MOD_SIZING_MEASURES
                            MOD_HEALTH_SCORES
                            MOD_SCORES
                            MOD_SIZING_EVOLUTION
                            MOD_HEALTH_EVOLUTION
                            MOD_TECHNO_SIZING_MEASURES
                            MOD_TECHNO_SCORES
                            MOD_TECHNO_SIZING_EVOLUTION
                            APP_FINDINGS_MEASURES
                            USR_EXCLUSIONS
                            USR_ACTION_PLAN
                            SRC_OBJECTS
                            SRC_TRANSACTIONS
                            SRC_TRX_OBJECTS
                            SRC_HEALTH_IMPACTS
                            SRC_TRX_HEALTH_IMPACTS
                            SRC_VIOLATIONS
                            SRC_MOD_OBJECTS      
                        EXEC curl rest/HD_ROOT/datamart/{table}
                EXEC transform refresh
                EXEC load 
                    TRUNCATE TABLE table CASCADE;
                    ALTER TABLE table ADD COLUMN IF NOT EXISTS...
                    COPY...
                        
        for each ed_domain
            EXEC datamart.py ED-INSTALL ED_ROOT[] DOMAINS_?.TXT
                transfer_ed_domains (ED_ROOT[], DOMAINS_?.TXT, JOBS)        
                    start_domain_transfer(ed_url, domains[pos], jobs, pos, "ed-install")
                        EXEC run ed-install ED_ROOT[] domains[pos]
                            EXEC extract ed-install ED_ROOT[]
                                for each table of
                                        APP_FINDINGS_MEASURES
                                        USR_EXCLUSIONS
                                        USR_ACTION_PLAN
                                        SRC_OBJECTS
                                        SRC_TRANSACTIONS
                                        SRC_TRX_OBJECTS
                                        SRC_HEALTH_IMPACTS
                                        SRC_TRX_HEALTH_IMPACTS
                                        SRC_VIOLATIONS
                                        SRC_MOD_OBJECTS 
                                    EXEC curl rest/ED_ROOT[]/datamart/{table}
                            EXEC transform ed-install
                            EXEC load 
                                TRUNCATE TABLE table CASCADE;
                                COPY...                        
```                        

## datamart update
```
EXEC datamart update    
    EXEC datamart.py HD-UPDATE
        transfer_aad_domain("hd-update")
            EXEC run hd-update HD_ROOT AAD
                EXEC extract hd-update HD_ROOT
                    for each table
                            DIM_SNAPSHOTS
                            DIM_RULES
                            DIM_OMG_RULES
                            DIM_CISQ_RULES
                            DIM_APPLICATIONS
                            APP_VIOLATIONS_MEASURES
                            APP_VIOLATIONS_EVOLUTION
                            APP_SIZING_MEASURES
                            APP_FUNCTIONAL_SIZING_MEASURES
                            APP_HEALTH_SCORES
                            APP_SCORES
                            APP_SIZING_EVOLUTION
                            APP_FUNCTIONAL_SIZING_EVOLUTION
                            APP_HEALTH_EVOLUTION
                            STD_RULES
                            STD_DESCRIPTIONS
                            APP_TECHNO_SIZING_MEASURES
                            APP_TECHNO_SCORES
                            APP_TECHNO_SIZING_EVOLUTION
                            MOD_VIOLATIONS_MEASURES
                            MOD_VIOLATIONS_EVOLUTION
                            MOD_SIZING_MEASURES
                            MOD_HEALTH_SCORES
                            MOD_SCORES
                            MOD_SIZING_EVOLUTION
                            MOD_HEALTH_EVOLUTION
                            MOD_TECHNO_SIZING_MEASURES
                            MOD_TECHNO_SCORES
                            MOD_TECHNO_SIZING_EVOLUTION                   
                        EXEC curl rest/ED_ROOT[]/datamart/{table}
                EXEC transform hd-update
                EXEC load
                    TRUNCATE TABLE table CASCADE;
                    ALTER TABLE table ADD COLUMN IF NOT EXISTS...
                    COPY...    
        
        for each ed_domain
            EXEC datamart.py ED-UPDATE ED_ROOT[] DOMAINS_?.TXT
                update_ed_domains (ED_ROOT, DOMAINS_?.TXT, JOBS, DATAMART_SNAPSHOTS.CSV)
                    EXEC check_new_snapshot.py # compare snapshots in Datamart, and snapshots in measurement base, skip applications with ne new snapshots
                    EXEC run ed-update ED_ROOT[] domains[pos]
                        EXEC extract ed-update ED_ROOT[]
                            for each table 
                                    APP_FINDINGS_MEASURES
                                    USR_EXCLUSIONS
                                    USR_ACTION_PLAN
                                    SRC_OBJECTS
                                    SRC_TRANSACTIONS
                                    SRC_TRX_OBJECTS
                                    SRC_HEALTH_IMPACTS
                                    SRC_TRX_HEALTH_IMPACTS
                                    SRC_VIOLATIONS
                                    SRC_MOD_OBJECTS       
                                EXEC curl rest/ED_ROOT[]/datamart/{table}
                        EXEC transform ed-update
                        EXEC load ed-update
                            DELETE FROM table WHERE...
                            COPY...
    ```
    
# Proposal for a new workflow

This workflow allows to copy a delta of data.

## New Command Line Interface
- ```datamart install``` should install schema only
- ```datamart upgrade``` should upgrade schema only (if target datamart has changed)
- ```datamart merge```   should allow to refresh data with new snapshots

## Some design principles

Distinct tables:
- tables from ED based on snapshot_id as primary key (use ED_ROOT)
- tables from ED with no snapshot_id as primary key  (use ED_ROOT)
- tables from HD with no snapshot_id as primary key  (use HD_ROOT)
   
We would need to extract data since a latest store date:
/rest/AED/datamart/APP_VIOLATIONS_MEASURES?after=2026-03-01

Maybe we would need to consider some datamart tables are staging tables (ex: DIM_RULES) to allow incremental update.
The copy of these data could be insert with a "ON CONFLICT DO NOTHING" clause.
