create or replace editionable trigger dbops.dbopb_before_alter_trg
    before create or alter or drop on database declare
        l_user      varchar2(200) := dbops_lock_pkg.get_user();
        l_locked_by dbops_locks.locked_by%type;
    begin
        l_locked_by := dbops_lock_pkg.is_object_locked(ora_dict_obj_type, ora_dict_obj_name, ora_dict_obj_owner);
        if nvl(l_locked_by, l_user) != l_user then
            raise_application_error(-20000,
                                    'DBOPS: '
                                    || initcap(ora_dict_obj_type)
                                    || ' '
                                    || ora_dict_obj_owner
                                    || '.'
                                    || ora_dict_obj_name
                                    || ' is locked by '
                                    || l_locked_by);

        end if;

    end;
/

alter trigger dbops.dbopb_before_alter_trg enable;


-- sqlcl_snapshot {"hash":"e0661aa1349710e754bf7426583a571075ef307f","type":"TRIGGER","name":"DBOPB_BEFORE_ALTER_TRG","schemaName":"DBOPS","sxml":"<TRIGGER  xmlns  =\"http://xmlns.oracle.com/ku\"  version  =\"1.0\"><SCHEMA>DBOPS</SCHEMA><NAME>DBOPB_BEFORE_ALTER_TRG</NAME><TRIGGER_TYPE>BEFORE</TRIGGER_TYPE><DATABASE_EVENT><EVENT_LIST><EVENT_LIST_ITEM><EVENT>ALTER</EVENT></EVENT_LIST_ITEM><EVENT_LIST_ITEM><EVENT>CREATE</EVENT></EVENT_LIST_ITEM><EVENT_LIST_ITEM><EVENT>DROP</EVENT></EVENT_LIST_ITEM></EVENT_LIST></DATABASE_EVENT><PLSQL_BLOCK>declare  l_user  varchar2  (200  ):=dbops_lock_pkg  .get_user  ();l_locked_by  dbops_locks  .locked_by  %type  ;begin  l_locked_by  :=dbops_lock_pkg  .is_object_locked  (ora_dict_obj_type  ,ora_dict_obj_name  ,ora_dict_obj_owner  );if  nvl  (l_locked_by  ,l_user  )!=l_user  then  raise_application_error  (-20000  ,'DBOPS: '  ||initcap  (ora_dict_obj_type  )||' '  ||ora_dict_obj_owner  ||'.'  ||ora_dict_obj_name  ||' is locked by '  ||l_locked_by  );end  if  ;end  ;</PLSQL_BLOCK></TRIGGER>"}