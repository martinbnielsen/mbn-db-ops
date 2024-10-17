# Ops tools for databases

The purpose of db-ops is to deliver tools that eases development and operations in the Oracle database development space.

The tools in this repository are open source and free to use. For feedback, questions or suggestions, please create an issue in the repository.

### Database object locking
Working with Oracle database objects in a team can be challenging. The adaption of source code management like "git" is not making this better, as the concept of locking does not exists, because the paradigm allowing developers to work of the same files, and to merge changes. This is not possible with database objects, as they are not text files, but stored in the database.

When multiple developers are working with the same database objects, there is a danger of one developer overwrting the changes of another developer. To avoid this, db-ops provides a locking mechanism that allows developers to lock database objects while they are working on them. This way, other developers will be notified that the object is locked and who has locked it.

When an object is locked, any attempt by to change this object will be blocked (using a database trigger).

*Developer-A: locks the object*
```sql
begin
 dbops_lock_pkg.lock_object(
  p_object_type => 'PROCEDURE', 
  p_object_name => 'OEHR_ADD_JOB_HISTORY', 
  p_notes       => 'I am working on this', 
  p_owner       => 'DEMO'
  );
end;
/

PL/SQL procedure successfully completed.

```
*Developer-B tried to alter the procedure*
```sql
alter procedure demo.oehr_add_job_history compile;

ORA-04088: error during execution of trigger 'DBOPS.DBOPB_BEFORE_ALTER_TRG'
ORA-00604: Error occurred at recursive SQL level 1. Check subsequent errors.
ORA-20000: DBOPS: Procedure DEMO.OEHR_ADD_JOB_HISTORY is locked by Developer-A
ORA-06512: at line 7
```

*Developer-A: releases the object when work is done*
```sql
begin
 dbops_lock_pkg.release_object(
  p_object_type => 'PROCEDURE', 
  p_object_name => 'OEHR_ADD_JOB_HISTORY', 
  p_owner       => 'DEMO'
  );
end;
/
```

If installing the APEX application, the locking and releasing can also be done through the APEX front-end.

Users are identifying either by their OS username:
```sql
sys_context('USERENV','OS_USER')
```
Or by their username in the APEX application (APP_USER), when logged into the APEX front-end.

## Installation

Pre-requisites:
* Oracle RDBMS 12c or higher
* APEX 22.2 or higher (optional)

The installation creates a new schema called DBOPS. The schema is created with a password that is provided during the installation. The schema is used to store the locking information and the APEX front-end is assigned to this schema.

To install db-ops, clone the repository and run the installation script:

```bash
SYS> @install_sys.sql <dbops password>

SYS> @install_sys_apex.sql (optional*)

DBOPS> @install_dbops.sql
```
\* The APEX installation script is optional and only required if you want to use the APEX front-end (and have APEX installed).

## Full API documentation

## The APEX application


