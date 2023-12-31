unit EmployeeReplacementQueryTexts;

interface

uses

  EmployeeReplacementTableDef;

const

  REPLACEABLE_EMPLOYEE_ID_PARAM_NAME =
    'p' + EMPLOYEE_REPLACEMENT_TABLE_REPLACEABLE_ID_FIELD;

  DELETE_ALL_REPLACEMENT_FOR_EMPLOYEE_QUERY =
    'DELETE FROM ' +
    EMPLOYEE_REPLACEMENT_TABLE_NAME +
    ' WHERE ' +
    EMPLOYEE_REPLACEMENT_TABLE_REPLACEABLE_ID_FIELD +
    '=:' +
    REPLACEABLE_EMPLOYEE_ID_PARAM_NAME;

implementation

end.
