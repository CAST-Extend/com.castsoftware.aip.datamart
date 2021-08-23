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

        BEGIN 
            CREATE TABLE APP_VIOLATIONS_EVOLUTION
            (
                SNAPSHOT_ID TEXT,
                RULE_ID TEXT,
                TECHNOLOGY TEXT,  
                METRIC_ID INT,
                NB_VIOLATIONS_ADDED INT,
                NB_VIOLATIONS_REMOVED INT,
                CONSTRAINT APP_VIOLATIONS_EVOLUTION_PKEY PRIMARY KEY (SNAPSHOT_ID, RULE_ID, TECHNOLOGY),
                FOREIGN KEY (RULE_ID) REFERENCES DIM_RULES (RULE_ID),
                FOREIGN KEY (SNAPSHOT_ID) REFERENCES DIM_SNAPSHOTS(SNAPSHOT_ID)
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Table APP_VIOLATIONS_EVOLUTION already exists';
        END;        
        
        BEGIN 
            CREATE TABLE MOD_VIOLATIONS_EVOLUTION
            (
                SNAPSHOT_ID TEXT,
                MODULE_NAME TEXT,    
                RULE_ID TEXT,
                TECHNOLOGY TEXT,  
                METRIC_ID INT,
                NB_VIOLATIONS_ADDED INT,
                NB_VIOLATIONS_REMOVED INT,
                CONSTRAINT MOD_VIOLATIONS_EVOLUTION_PKEY PRIMARY KEY (SNAPSHOT_ID, MODULE_NAME, RULE_ID, TECHNOLOGY),
                FOREIGN KEY (RULE_ID) REFERENCES DIM_RULES (RULE_ID),
                FOREIGN KEY (SNAPSHOT_ID) REFERENCES DIM_SNAPSHOTS(SNAPSHOT_ID)
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Table MOD_VIOLATIONS_EVOLUTION already exists';
        END;
        
        BEGIN 
            CREATE TABLE APP_TECHNO_SIZING_MEASURES
            (
                SNAPSHOT_ID TEXT,
                TECHNOLOGY TEXT,
                NB_ARTIFACTS INT,
                NB_CODE_LINES INT,
                NB_COMMENT_LINES INT,
                NB_COMMENTED_OUT_CODE_LINES INT,
                NB_CRITICAL_VIOLATIONS INT,
                NB_DECISION_POINTS INT,
                NB_FILES INT,
                NB_TABLES INT,
                NB_VIOLATIONS INT,
                NB_VIOLATIONS_EXCLUDED INT,    
                NB_VIOLATIONS_FIXED_ACTION_PLAN INT,
                NB_VIOLATIONS_PENDING_ACTION_PLAN INT,        
                TECHNICAL_DEBT_DENSITY NUMERIC,
                TECHNICAL_DEBT_TOTAL NUMERIC,
                CONSTRAINT APP_TECHNO_SIZING_MEASURES_PKEY PRIMARY KEY (SNAPSHOT_ID, TECHNOLOGY),
                FOREIGN KEY (SNAPSHOT_ID) REFERENCES DIM_SNAPSHOTS(SNAPSHOT_ID)
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Table APP_TECHNO_SIZING_MEASURES already exists';
        END;
    
        BEGIN 
            CREATE TABLE MOD_TECHNO_SIZING_MEASURES
            (
                SNAPSHOT_ID TEXT,
                MODULE_NAME TEXT,
                TECHNOLOGY TEXT,
                NB_ARTIFACTS INT,
                NB_CODE_LINES INT,
                NB_COMMENT_LINES INT,
                NB_COMMENTED_OUT_CODE_LINES INT,
                NB_CRITICAL_VIOLATIONS INT,
                NB_DECISION_POINTS INT,
                NB_FILES INT,
                NB_TABLES INT,
                NB_VIOLATIONS INT,
                TECHNICAL_DEBT_DENSITY NUMERIC,
                TECHNICAL_DEBT_TOTAL NUMERIC,
                CONSTRAINT MOD_TECHNO_SIZING_MEASURES_PKEY PRIMARY KEY (SNAPSHOT_ID, MODULE_NAME, TECHNOLOGY),
                FOREIGN KEY (SNAPSHOT_ID) REFERENCES DIM_SNAPSHOTS(SNAPSHOT_ID)
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Table MOD_TECHNO_SIZING_MEASURES already exists';
        END;
        
        BEGIN 
            CREATE TABLE APP_TECHNO_SCORES
            (
                SNAPSHOT_ID TEXT,
                TECHNOLOGY TEXT,
                METRIC_ID INT,
                METRIC_NAME TEXT,
                METRIC_TYPE TEXT,
                SCORE DECIMAL,
                CONSTRAINT APP_TECHNO_SCORES_PKEY PRIMARY KEY (SNAPSHOT_ID, METRIC_ID, TECHNOLOGY),
                FOREIGN KEY (SNAPSHOT_ID) REFERENCES DIM_SNAPSHOTS(SNAPSHOT_ID)
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Table APP_TECHNO_SCORES already exists';
        END;

        BEGIN 
            CREATE TABLE MOD_TECHNO_SCORES
            (
                SNAPSHOT_ID TEXT,
                MODULE_NAME TEXT,
                TECHNOLOGY TEXT,
                METRIC_ID INT,
                METRIC_NAME TEXT,
                METRIC_TYPE TEXT,
                SCORE DECIMAL,
                CONSTRAINT MOD_TECHNO_SCORES_PKEY PRIMARY KEY (SNAPSHOT_ID, MODULE_NAME, METRIC_ID, TECHNOLOGY),
                FOREIGN KEY (SNAPSHOT_ID) REFERENCES DIM_SNAPSHOTS(SNAPSHOT_ID)
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Table MOD_TECHNO_SCORES already exists';
        END;
        
    END;
$$
