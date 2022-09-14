unit EmployeesViewQueryTextsUnit;

interface

uses

  EmployeeViewDef;

const

  EMPLOYEE_ID_PARAM_NAME = 'pemployee_id';

  SELECT_ALL_EMPLOYEES_QUERY =
    'SELECT * FROM ' + EMPLOYEE_VIEW_TABLE_NAME;

  SELECT_DOCUMENT_RESPONSIBLES_QUERY =
    'SELECT ' +
    'a.id AS ' + EMPLOYEE_VIEW_TABLE_ID_FIELD + ',' +
    'a.tab_nbr AS ' + EMPLOYEE_VIEW_TABLE_PERSONNEL_NUMBER_FIELD + ',' +
    '(upper(substring(a.name, 1, 1)) || lower(substring(a.name, 2, length(a.name) - 1))) AS ' + EMPLOYEE_VIEW_TABLE_NAME_FIELD + ',' +
    '(upper(substring(a.family, 1, 1)) || lower(substring(a.family, 2, length(a.family) - 1))) AS ' + EMPLOYEE_VIEW_TABLE_SURNAME_FIELD + ',' +
    '(upper(substring(a.patronymic, 1, 1)) || lower(substring(a.patronymic, 2, length(a.patronymic) - 1))) AS ' + EMPLOYEE_VIEW_TABLE_PATRONYMIC_FIELD + ',' +
    'a.job AS ' + EMPLOYEE_VIEW_TABLE_SPECIALITY_FIELD + ',' +
    'b.podr_code AS ' + EMPLOYEE_VIEW_TABLE_DEPARTMENT_CODE_FIELD + ',' +
    'b.podr_short_name AS ' + EMPLOYEE_VIEW_TABLE_DEPARTMENT_SHORT_NAME_FIELD + ',' +
    'b.podr_name AS ' + EMPLOYEE_VIEW_TABLE_DEPARTMENT_FULL_NAME_FIELD + ',' +
    'c.telephone_number AS ' + EMPLOYEE_VIEW_TABLE_TELEPHONE_NUMBER_FIELD +
    ' FROM  ' +
    'exchange.spr_person a  ' +
    'JOIN nsi.spr_podr b ON a.podr_id = b.id ' +
    'LEFT JOIN exchange.spr_person_telephone_numbers c ON c.person_id = a.id ' +
    'WHERE NOT a.dismissed AND b.end_isp_dt = ''9999-12-31''::::date';

implementation

end.
