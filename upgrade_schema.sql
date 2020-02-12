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
            CREATE TABLE SRC_TRX_HEALTH_IMPACTS
            (
                APPLICATION_NAME INT,
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
