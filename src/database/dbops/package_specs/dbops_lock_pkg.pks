create or replace package dbops.dbops_lock_pkg is
    function get_user return varchar2;

    function is_object_locked (
        p_object_type in dbops_locks.object_type%type,
        p_object_name in dbops_locks.object_name%type,
        p_owner       in dbops_locks.owner%type default sys_context('USERENV', 'CURRENT_SCHEMA')
    ) return dbops_locks.locked_by%type;

    procedure lock_object (
        p_object_type in dbops_locks.object_type%type,
        p_object_name in dbops_locks.object_name%type,
        p_notes       in dbops_locks.notes%type default null,
        p_owner       in dbops_locks.owner%type default sys_context('USERENV', 'CURRENT_SCHEMA')
    );

    procedure release_object (
        p_object_type in dbops_locks.object_type%type,
        p_object_name in dbops_locks.object_name%type,
        p_owner       in dbops_locks.owner%type default sys_context('USERENV', 'CURRENT_SCHEMA')
    );

    procedure print_locks (
        p_object_type in dbops_locks.object_type%type default '%',
        p_object_name in dbops_locks.object_name%type default '%',
        p_owner       in dbops_locks.owner%type default sys_context('USERENV', 'CURRENT_SCHEMA')
    );

    function is_admin return varchar2;

end dbops_lock_pkg;
/


-- sqlcl_snapshot {"hash":"36a69abbbf793451c8ab748995e2c76ebecf4edd","type":"PACKAGE_SPEC","name":"DBOPS_LOCK_PKG","schemaName":"DBOPS"}