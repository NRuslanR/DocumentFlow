unit SelectDocumentRecordsViewQueries;

interface

const

  EMPLOYEE_PARAM_NAME = ':pemployee_id';
  STAGE_NAMES_PARAM_NAME = ':pstage_names';
  DOCUMENT_IDS_PARAM_NAME = ':pdocument_ids';
  DEPARTMENT_IDS_PARAM_NAME = ':pdepartment_ids';

  SELECT_ALL_OUTCOMING_SERVICE_NOTES_FOR_EMPLOYEE_QUERY =
    'SELECT * FROM doc.get_outcoming_service_notes_for_employee(' + EMPLOYEE_PARAM_NAME + ')';

  SELECT_OUTCOMING_SERVICE_NOTES_FOR_EMPLOYEE_BY_STAGE_NAMES_QUERY =
    'SELECT * FROM doc.get_outcoming_service_notes_for_employee(' + EMPLOYEE_PARAM_NAME + ', ARRAY[' + STAGE_NAMES_PARAM_NAME + '])';

  SELECT_OUTCOMING_SERVICE_NOTES_FOR_EMPLOYEE_BY_IDS_QUERY =
    'SELECT * FROM doc.get_outcoming_service_notes_for_employee_by_ids(' + EMPLOYEE_PARAM_NAME + ', ARRAY[' + DOCUMENT_IDS_PARAM_NAME + '])';

  SELECT_ALL_OUTCOMING_SERVICE_NOTES_FROM_DEPARTMENTS_QUERY =
    'SELECT * FROM doc.get_outcoming_service_notes_from_departments(' + DEPARTMENT_IDS_PARAM_NAME + ')';

  SELECT_DEPARTMENT_OUTCOMING_SERVICE_NOTES_BY_IDS_QUERY =
    'SELECT * FROM doc.get_department_outcoming_service_notes_by_ids(' + DOCUMENT_IDS_PARAM_NAME + ')';



  SELECT_ALL_SERVICE_NOTES_FOR_APPROVING_FOR_EMPLOYEE_QUERY =
    'SELECT * FROM doc.get_approveable_service_notes_for_employee(' + EMPLOYEE_PARAM_NAME + ')';

  SELECT_SERVICE_NOTES_FOR_APPROVING_FOR_EMPLOYEE_BY_STAGE_NAMES_QUERY =
    'SELECT * FROM doc.get_approveable_service_notes_for_employee(' + EMPLOYEE_PARAM_NAME + ', ARRAY[' + STAGE_NAMES_PARAM_NAME + '])';

  SELECT_APPROVEABLE_SERVICE_NOTES_FOR_EMPLOYEE_BY_IDS_QUERY =
    'SELECT * FROM doc.get_approveable_service_notes_for_employee_by_ids(' + EMPLOYEE_PARAM_NAME + ', ARRAY[' + DOCUMENT_IDS_PARAM_NAME + '])';

  SELECT_ALL_APPROVEABLE_SERVICE_NOTES_FROM_DEPARTMENTS_QUERY =
    'SELECT * FROM doc.get_approveable_service_notes_from_departments(' + DEPARTMENT_IDS_PARAM_NAME + ')';

  SELECT_DEPARTMENT_APPROVEABLE_SERVICE_NOTES_BY_IDS_QUERY =
    'SELECT * FROM doc.get_department_approveable_service_notes_by_ids(' + DOCUMENT_IDS_PARAM_NAME + ')';



  SELECT_ALL_INCOMING_SERVICE_NOTES_FOR_EMPLOYEE_QUERY =
    'SELECT * FROM doc.get_incoming_service_notes_for_employee(' + EMPLOYEE_PARAM_NAME + ')';

  SELECT_INCOMING_SERVICE_NOTES_FOR_EMPLOYEE_BY_STAGE_NAMES_QUERY =
    'SELECT * FROM doc.get_incoming_service_notes_for_employee(' + EMPLOYEE_PARAM_NAME + ', ARRAY[' + STAGE_NAMES_PARAM_NAME + '])';

  SELECT_INCOMING_SERVICE_NOTES_FOR_EMPLOYEE_BY_IDS_QUERY =
    'SELECT * FROM doc.get_incoming_service_notes_for_employee_by_ids(' + EMPLOYEE_PARAM_NAME + ', ARRAY[' + DOCUMENT_IDS_PARAM_NAME + '])';

  SELECT_ALL_INCOMING_SERVICE_NOTES_FROM_DEPARTMENTS_QUERY =
    'SELECT * FROM doc.get_incoming_service_notes_from_departments(' + DEPARTMENT_IDS_PARAM_NAME + ')';

  SELECT_DEPARTMENT_INCOMING_SERVICE_NOTES_BY_IDS_QUERY =
    'SELECT * FROM doc.get_department_incoming_service_notes_by_ids(' + DOCUMENT_IDS_PARAM_NAME + ')';



  SELECT_ALL_PERSONNEL_ORDERS_FOR_EMPLOYEE_QUERY =
    'SELECT * FROM doc.get_personnel_orders_for_employee(' + EMPLOYEE_PARAM_NAME + ')';

  SELECT_PERSONNEL_ORDERS_FOR_EMPLOYEE_BY_IDS_QUERY =
    'SELECT * FROM doc.get_personnel_orders_for_employee_by_ids(' + EMPLOYEE_PARAM_NAME + ', ARRAY[' + DOCUMENT_IDS_PARAM_NAME + '])';

  SELECT_PERSONNEL_ORDERS_FROM_DEPARTMENTS_QUERY =
    'SELECT * FROM doc.get_personnel_orders_from_departments(' + DEPARTMENT_IDS_PARAM_NAME + ')';

  SELECT_DEPARTMENT_PERSONNEL_ORDERS_BY_IDS_QUERY =
    'SELECT * FROM doc.get_department_personnel_orders_by_ids(' + DOCUMENT_IDS_PARAM_NAME + ')';



  SELECT_ALL_INTERNAL_SERVICE_NOTES_FOR_EMPLOYEE_QUERY =
    'SELECT * FROM doc.get_internal_service_notes_for_employee(' + EMPLOYEE_PARAM_NAME + ')';
    
implementation

end.
