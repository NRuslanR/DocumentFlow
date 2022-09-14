unit EmployeePostgresRepositoryQueryTextsUnit;

interface

uses

  EmployeeTableDef,
  RoleTableDef;

const

  SELECT_EMPLOYEE_ROLE_ID_FIELD =
    ROLE_TABLE_ID_FIELD + ' as ' + EMPLOYEE_ROLE_ID_FIELD;

  SELECT_EMPLOYEE_ROLE_NAME_FIELD =
    ROLE_TABLE_NAME_FIELD + ' as ' + EMPLOYEE_ROLE_NAME_FIELD;

  SELECT_EMPLOYEE_ROLE_DESCRIPTION_FIELD =
   ROLE_TABLE_DESCRIPTION_FIELD + ' as ' + EMPLOYEE_ROLE_DESCRIPTION_FIELD;
  
  EMPLOYEE_ID_PARAM_NAME = 'p' + EMPLOYEE_TABLE_ID_FIELD;

  FIND_ALL_LEADERS_FOR_EMPLOYEE_QUERY =
    'SELECT * FROM doc.find_all_leaders_with_roles_for_employee(:' +
      EMPLOYEE_ID_PARAM_NAME +
    ')';
    
implementation

end.
