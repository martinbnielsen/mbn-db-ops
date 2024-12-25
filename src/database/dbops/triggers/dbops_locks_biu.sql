create or replace editionable trigger dbops.dbops_locks_biu before
    insert or update on dbops.dbops_locks
    for each row
begin
    if inserting then
        :new.created := localtimestamp;
        :new.created_by := coalesce(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        );
    end if;

    :new.updated := localtimestamp;
    :new.updated_by := coalesce(
        sys_context('APEX$SESSION', 'APP_USER'),
        user
    );
end dbops_locks_biu;
/

alter trigger dbops.dbops_locks_biu enable;


-- sqlcl_snapshot {"hash":"4d36fb07a914037795ecdb9818dcdb9cf34511af","type":"TRIGGER","name":"DBOPS_LOCKS_BIU","schemaName":"DBOPS","sxml":"<TRIGGER  xmlns  =\"http://xmlns.oracle.com/ku\"  version  =\"1.0\"><SCHEMA>DBOPS</SCHEMA><NAME>DBOPS_LOCKS_BIU</NAME><TRIGGER_TYPE>BEFORE</TRIGGER_TYPE><DML_EVENT><EVENT_LIST><EVENT_LIST_ITEM><EVENT>INSERT</EVENT></EVENT_LIST_ITEM><EVENT_LIST_ITEM><EVENT>UPDATE</EVENT></EVENT_LIST_ITEM></EVENT_LIST><SCHEMA>DBOPS</SCHEMA><NAME>DBOPS_LOCKS</NAME><REFERENCING><FOR_EACH_ROW></FOR_EACH_ROW></REFERENCING></DML_EVENT><PLSQL_BLOCK>begin  if  inserting  then  :new  .created  :=localtimestamp  ;:new  .created_by  :=coalesce  (sys_context  ('APEX$SESSION'  ,'APP_USER'  ),user  );end  if  ;:new  .updated  :=localtimestamp  ;:new  .updated_by  :=coalesce  (sys_context  ('APEX$SESSION'  ,'APP_USER'  ),user  );end  dbops_locks_biu  ;</PLSQL_BLOCK></TRIGGER>"}