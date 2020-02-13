set search_path to :schema;
DO $$ 
    BEGIN
        BEGIN 
            ALTER TABLE DIM_SNAPSHOTS ADD COLUMN VERSION TEXT;
        EXCEPTION
            WHEN OTHERS THEN 
                RAISE NOTICE 'column VERSION already exists for DIM_SNAPSHOTS';
        END;

        BEGIN 
            ALTER TABLE SRC_HEALTH_IMPACTS ADD COLUMN SNAPSHOT_ID TEXT;
        EXCEPTION
            WHEN OTHERS THEN 
                RAISE NOTICE 'column SNAPSHOT_ID already exists for SRC_HEALTH_IMPACTS';
        END;

        BEGIN 

            ALTER TABLE SRC_HEALTH_IMPACTS ADD COLUMN NB_VIOLATIONS INT;
        EXCEPTION
            WHEN OTHERS THEN 
                RAISE NOTICE 'column NB_VIOLATIONS already exists for SRC_HEALTH_IMPACTS';
        END;

        BEGIN 
            ALTER TABLE SRC_HEALTH_IMPACTS ADD COLUMN NB_VIOLATED_RULES INT;
        EXCEPTION
            WHEN OTHERS THEN 
                RAISE NOTICE 'column NB_VIOLATED_RULES already exists for SRC_HEALTH_IMPACTS';
        END;
        
        BEGIN 
            CREATE TABLE SRC_TRX_HEALTH_IMPACTS
            (
                APPLICATION_NAME TEXT,
                SNAPSHOT_ID TEXT,
                TRX_ID  TEXT,
                TRX_NAME TEXT,
                SECURITY_RISK_INDEX INT,
                EFFICIENCY_RISK_INDEX INT,
                ROBUSTNESS_RISK_INDEX INT,
                CONSTRAINT SRC_TRX_HEALTH_IMPACTS_PKEY PRIMARY KEY (SNAPSHOT_ID, TRX_ID)
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Table SRC_TRX_HEALTH_IMPACTS already exists';
        END;
    END;
$$
