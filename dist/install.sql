-- Use the SQLCL engine for formatted sql changelog not the JDBC engine
-- The value can be sqlcl or
-- liquibase set engine sqlcl

-- Prechecks modifiable helper
-- Check running with SQLcl
-- Check minimum DB version
-- Check character set
-- @utils/prechecks.sql

-- SLOT
-- Custom pre Liquibase code here (perhaps creation of a schema)
-- This is MINIMAL pre setup, everything that can go through Liquibase - SHOULD

-- Kick off Liquibase
prompt "Installing/updating schemas"
lb update -log -changelog-file releases/main.changelog.xml -search-path "."

--@utils/recompile.sql