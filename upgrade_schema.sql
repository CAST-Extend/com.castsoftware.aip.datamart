set search_path to :schema;
DO $$ 
    BEGIN

        BEGIN 
            ALTER TABLE DIM_SNAPSHOTS ADD COLUMN VERSION TEXT;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column VERSION already exists in DIM_SNAPSHOTS';
        END;
    END;
$$
