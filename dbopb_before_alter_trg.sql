create or replace trigger dbopb_before_alter_trg
  before create or alter or drop
  on database
  when (ora_dict_obj_owner != 'DBOPS')
  declare
    l_user      varchar2(200) := dbops_lock_pkg.get_user();
    l_locked_by dbops_locks.locked_by%type;
  begin
    l_locked_by := dbops_lock_pkg.is_object_locked(ora_dict_obj_type, ora_dict_obj_name, ora_dict_obj_owner);
    if nvl(l_locked_by, l_user) != l_user then
      raise_application_error(-20000, 'DBOPS: ' || initcap(ora_dict_obj_type) || ' '  || ora_dict_obj_owner || '.' || ora_dict_obj_name||' is locked by '||l_locked_by);
    end if;
  end;
/
