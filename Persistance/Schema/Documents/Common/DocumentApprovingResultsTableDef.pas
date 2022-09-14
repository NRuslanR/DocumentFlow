unit DocumentApprovingResultsTableDef;

interface

uses

  TableDef;
  
const

  DOCUMENT_APPROVING_RESULTS_TABLE_NAME = 'doc.document_approving_results';
  DOCUMENT_APPROVING_RESULTS_TABLE_ID_FIELD = 'id';
  DOCUMENT_APPROVING_RESULTS_TABLE_RESULT_NAME_FIELD = 'result_name';

  DOCUMENT_APPROVED_RESULT_ID = 1;
  DOCUMENT_NOT_APPROVED_RESULT_ID = 2;
  DOCUMENT_APPROVING_NOT_PERFORMED_RESULT_ID = 3;

type

  TDocumentApprovingResultsTableDef = class (TTableDef)

    NameColumnName: String;
    
  end;
  
implementation

end.
