create or replace editionable trigger dbops.dbops_schemas_biu before
    insert or update on dbops.dbops_schemas
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
end dbops_schemas_biu;
/

alter trigger dbops.dbops_schemas_biu enable;


-- sqlcl_snapshot {"hash":"d3cb84c5b467c8a7c9005ae65cd3563890b0ae1a","type":"TRIGGER","name":"DBOPS_SCHEMAS_BIU","schemaName":"DBOPS","sxml":"<TRIGGER  xmlns  =\"http://xmlns.oracle.com/ku\"  version  =\"1.0\"><SCHEMA>DBOPS</SCHEMA><NAME>DBOPS_SCHEMAS_BIU</NAME><TRIGGER_TYPE>BEFORE</TRIGGER_TYPE><DML_EVENT><EVENT_LIST><EVENT_LIST_ITEM><EVENT>INSERT</EVENT></EVENT_LIST_ITEM><EVENT_LIST_ITEM><EVENT>UPDATE</EVENT></EVENT_LIST_ITEM></EVENT_LIST><SCHEMA>DBOPS</SCHEMA><NAME>DBOPS_SCHEMAS</NAME><REFERENCING><FOR_EACH_ROW></FOR_EACH_ROW></REFERENCING></DML_EVENT><PLSQL_BLOCK>begin  if  inserting  then  :new  .created  :=localtimestamp  ;:new  .created_by  :=coalesce  (sys_context  ('APEX$SESSION'  ,'APP_USER'  ),user  );end  if  ;:new  .updated  :=localtimestamp  ;:new  .updated_by  :=coalesce  (sys_context  ('APEX$SESSION'  ,'APP_USER'  ),user  );end  dbops_schemas_biu  ;</PLSQL_BLOCK></TRIGGER>"}