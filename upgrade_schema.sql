set search_path to :schema;
/*
 * Sample script to synchronize schema with an upgraded version of the datamart services
 */
--DO $$ 
--    BEGIN
--
--        BEGIN 
--            ALTER TABLE DIM_SNAPSHOTS ADD COLUMN YEAR_QUARTER TEXT;
--        EXCEPTION
--            WHEN duplicate_column THEN RAISE NOTICE 'column YEAR_QUARTER already exists in DIM_SNAPSHOTS';
--        END;
--
--        BEGIN
--            ALTER TABLE DIM_SNAPSHOTS ADD COLUMN YEAR_MONTH TEXT;
--        EXCEPTION
--            WHEN duplicate_column THEN RAISE NOTICE 'column YEAR_MONTH already exists in DIM_SNAPSHOTS';
--        END;
--
--        BEGIN
--            ALTER TABLE DIM_SNAPSHOTS ADD COLUMN YEAR_WEEK TEXT;
--        EXCEPTION
--            WHEN duplicate_column THEN RAISE NOTICE 'column YEAR_WEEK already exists in DIM_SNAPSHOTS';
--        END;
--    END;
--$$
