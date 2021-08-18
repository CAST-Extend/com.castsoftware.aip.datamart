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
            ALTER TABLE DIM_SNAPSHOTS ADD COLUMN CONSOLIDATION_MODE TEXT;
        EXCEPTION
            WHEN OTHERS THEN 
                RAISE NOTICE 'column CONSOLIDATION_MODE already exists for DIM_SNAPSHOTS';
        END;

        BEGIN 
            ALTER TABLE DIM_SNAPSHOTS ADD COLUMN INTERNAL_ID INT;
        EXCEPTION
            WHEN OTHERS THEN 
                RAISE NOTICE 'column INTERNAL_ID already exists for DIM_SNAPSHOTS';
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
        
        BEGIN 
            CREATE TABLE DIM_OMG_RULES
            (
                RULE_ID TEXT,
                RULE_NAME TEXT,
                TECHNICAL_CRITERION_NAME TEXT,  
                IS_CRITICAL BOOLEAN,
                WEIGHT NUMERIC,
                WEIGHT_OMG_MAINTAINABILITY NUMERIC,
                WEIGHT_OMG_EFFICIENCY NUMERIC,
                WEIGHT_OMG_RELIABILITY NUMERIC,
                WEIGHT_OMG_SECURITY NUMERIC,
                WEIGHT_OMG_INDEX NUMERIC,
                CONSTRAINT DIM_OMG_RULES_PKEY PRIMARY KEY (RULE_ID)
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Table DIM_OMG_RULES already exists';
        END;
        
        BEGIN 
            CREATE TABLE DIM_CISQ_RULES
            (
                RULE_ID TEXT,
                RULE_NAME TEXT,
                TECHNICAL_CRITERION_NAME TEXT,  
                IS_CRITICAL BOOLEAN,
                WEIGHT NUMERIC,
                WEIGHT_CISQ_MAINTAINABILITY NUMERIC,
                WEIGHT_CISQ_EFFICIENCY NUMERIC,
                WEIGHT_CISQ_RELIABILITY NUMERIC,
                WEIGHT_CISQ_SECURITY NUMERIC,
                WEIGHT_CISQ_INDEX NUMERIC,
                CONSTRAINT DIM_CISQ_RULES_PKEY PRIMARY KEY (RULE_ID)
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Table DIM_CISQ_RULES already exists';
        END;        
    END;
$$
