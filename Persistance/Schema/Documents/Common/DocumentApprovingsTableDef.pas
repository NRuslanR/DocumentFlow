unit DocumentApprovingsTableDef;

interface

uses

  TableDef;

const

  DOCUMENT_APPROVINGS_TABLE_NAME = 'doc.document_approvings';

  DOCUMENT_APPROVINGS_TABLE_ID_FIELD = 'id';
  DOCUMENT_APPROVINGS_TABLE_DOCUMENT_ID_FIELD = 'document_id';
  DOCUMENT_APPROVINGS_TABLE_PERFORMING_DATE_FIELD = 'performing_date';
  DOCUMENT_APPROVINGS_TABLE_PERFORMING_RESULT_ID_FIELD = 'performing_result_id';
  DOCUMENT_APPROVINGS_TABLE_APPROVER_ID_FIELD = 'approver_id';
  DOCUMENT_APPROVINGS_TABLE_ACTUAL_PERFORMED_EMPLOYEE_ID_FIELD = 'actual_performed_employee_id';
  DOCUMENT_APPROVINGS_TABLE_NOTE_FIELD = 'note';
  DOCUMENT_APPROVINGS_TABLE_CYCLE_NUMBER_FIELD = 'cycle_number';

type

  TDocumentApprovingsTableDef = class (TTableDef)

    public

      DocumentIdColumnName: String;
      PerformingDateColumnName: String;
      PerformingResultIdColumnName: String;
      ApproverIdColumnName: String;
      ActualPerformedEmployeeIdColumnName: String;
      NoteColumnName: String;
      CycleNumberColumnName: String;

  end;
  
implementation

end.
