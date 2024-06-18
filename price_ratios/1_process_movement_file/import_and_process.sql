-- import_and_process.sql

-- Initial setup
PRAGMA journal_mode = OFF;
PRAGMA synchronous = OFF;
PRAGMA cache_size = 1000000;  -- Adjust based on available memory
PRAGMA temp_store = MEMORY;
PRAGMA locking_mode = EXCLUSIVE;

-- Create the table
CREATE TABLE IF NOT EXISTS raw_movement (
    store_code_uc TEXT,
    upc TEXT,
    week_end TEXT,
    units INTEGER,
    prmult INTEGER,
    price REAL,
    feature INTEGER,
    display INTEGER
);

-- Re-enable normal settings after updates
PRAGMA journal_mode = DELETE;
PRAGMA synchronous = FULL;