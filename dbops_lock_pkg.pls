CREATE OR REPLACE PACKAGE dbops_lock_pkg IS
    PROCEDURE lock_object(p_schema_name IN VARCHAR2, p_object_name IN VARCHAR2);
    PROCEDURE release_object(p_schema_name IN VARCHAR2, p_object_name IN VARCHAR2);
END dbops_lock_pkg;
/