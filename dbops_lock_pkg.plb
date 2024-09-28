create or replace package body dbops_lock_pkg is

    procedure lock_object(p_schema_name in varchar2, p_object_name in varchar2) is
        v_sql varchar2(1000);
    begin
        null;
    exception
        when others then
            dbms_output.put_line('error locking object: ' || sqlerrm);
    end lock_object;

    procedure release_object(p_schema_name in varchar2, p_object_name in varchar2) is
    begin
        -- in oracle, locks are automatically released at the end of the transaction.
        -- this procedure can be used to commit the transaction to release the lock.
        commit;
    exception
        when others then
            dbms_output.put_line('error releasing lock: ' || sqlerrm);
    end release_object;

end dbops_lock_pkg;
/