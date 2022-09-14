unit DocumentTypeStageTableDef;

interface

uses

  TableDef;
  
const

  DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_NAME =
    'doc.document_type_work_cycle_stages';

  DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_ID_FIELD = 'id';
  DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_DOCUMENT_TYPE_ID = 'document_type_id';
  DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_NAME_FIELD = 'stage_name';
  DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_NUMBER_FIELD = 'stage_number';
  DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_SERVICE_STAGE_NAME_FIELD = 'service_stage_name';
  
  DOCUMENT_TYPE_WORK_CYCLE_STAGE_TABLE_ALIAS_ID_FIELD = 'stage_id';
  
  SERVICE_NOTE_CREATED_STAGE_ID = 2;
  SERVICE_NOTE_PERFORMED_STAGE_ID = 1;
  SERVICE_NOTE_PERFORMING_STAGE_ID = 4;
  SERVICE_NOTE_SIGNING_STAGE_ID = 3;
  SERVICE_NOTE_SIGNED_STAGE_ID = 21;
  SERVICE_NOTE_REJECTED_FROM_SIGNING_STAGE_ID = 5;
  SERVICE_NOTE_APPROVING_STAGE_ID = 8;
  SERVICE_NOTE_APPROVED_STAGE_ID = 9;
  SERVICE_NOTE_NOT_APPROVED_STAGE_ID = 10;

type

  TDocumentTypeStageTableDef = class (TTableDef)

    public

      DocumentTypeIdColumnName: String;
      StageNameColumnName: String;
      StageNumberColumnName: String;
      ServiceStageNameColumnName: String;

  end;


implementation

end.
