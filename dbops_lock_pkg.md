# DBOPS_LOCK_PKG






 
- [GET_USER Function](#get_user)
 
- [IS_OBJECT_LOCKED Function](#is_object_locked)
 
- [LOCK_OBJECT Procedure](#lock_object)












 
## GET_USER Function<a name="get_user"></a>


<p>
<p>Fetch current user from APEX or database session</p>
</p>

### Syntax
```plsql
function get_user return varchar2
```

### Parameters
Name | Description
--- | ---
*return* | Current authenticated user
 
 


### Example
```plsql
select dbops_lock_pkg.get_user from dual;
```



 
## IS_OBJECT_LOCKED Function<a name="is_object_locked"></a>


<p>
<p>Check if an object is locked</p>
</p>

### Syntax
```plsql
function is_object_locked(
  p_object_type in dbops_locks.object_type%TYPE, 
  p_object_name in dbops_locks.object_name%TYPE,
  p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA') 
) return dbops_locks.locked_by%TYPE
```

### Parameters
Name | Description
--- | ---
`p_object_type` | Object type (PACKAGE, PACKAGE BODY, TABLE, VIEW, etc)
`p_object_name` | Name of the object
`p_owner` | Owner of the object (defaults to current schema)
*return* | NULL if object is not locked, otherwise the user who locked it
 
 


### Example
```plsql
select dbops_lock_pkg.is_object_locked('PROCEDURE', 'MY_PROCEDURE') from dual;
```



 
## LOCK_OBJECT Procedure<a name="lock_object"></a>


<p>
<p>Lock a database object</p>
</p>

### Syntax
```plsql
procedure lock_object(
  p_object_type in dbops_locks.object_type%TYPE, 
  p_object_name in dbops_locks.object_name%TYPE,
  p_notes       in dbops_locks.notes%TYPE default null,
  p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA')
)
```

### Parameters
Name | Description
--- | ---
`p_object_type` | Object type (PACKAGE, PACKAGE BODY, TABLE, VIEW, etc)
`p_object_name` | Name of the object
`p_notes` | Optional notes
`p_owner` | Owner of the object (defaults to current schema)
 
 


### Example
```plsql
exec dbops_lock_pkg.lock_object('PROCEDURE', 'MY_PROCEDURE', 'Testing locking');
```

### Thrown exceptions
*throws* -20000 Schema not supported<br />
-20001 Object is already locked<br />
-20002 Object does not exist


 
