unit DocumentTableDef;

interface

uses

  TableDef;

const

  DOCUMENT_TABLE_NAME = 'doc.documents';

  DOCUMENT_TABLE_ID_FIELD = 'id';
  DOCUMENT_TABLE_NAME_FIELD = 'name';
  DOCUMENT_TABLE_TYPE_ID_FIELD = 'type_id';
  DOCUMENT_TABLE_DOCUMENT_NUMBER_FIELD = 'document_number';
  DOCUMENT_TABLE_CREATION_DATE_FIELD = 'creation_date';
  DOCUMENT_TABLE_DOCUMENT_DATE_FIELD = 'document_date';
  DOCUMENT_TABLE_NOTE_FIELD = 'note';
  DOCUMENT_TABLE_CONTENT_FIELD = 'content';
  DOCUMENT_TABLE_PRODUCT_CODE_FIELD = 'product_code';
  DOCUMENT_TABLE_AUTHOR_ID_FIELD = 'author_id';
  DOCUMENT_TABLE_CURRENT_WORK_CYCLE_STAGE_ID_FIELD = 'current_work_cycle_stage_id';
  DOCUMENT_TABLE_RESPONSIBLE_ID_FIELD = 'performer_id';
  DOCUMENT_TABLE_IS_SENT_TO_SIGNING_FIELD = 'is_sent_to_signing';
  DOCUMENT_TABLE_IS_SELF_REGISTERED_FIELD = 'is_self_registered';

type

  TDocumentTableDef = class (TTableDef)

    public

      NameColumnName: String;
      TypeIdColumnName: String;
      NumberColumnName: String;
      CreationDateColumnName: String;
      DocumentDateColumnName: String;
      NoteColumnName: String;
      ContentColumnName: String;
      AuthorIdColumnName: String;
      ProductCodeColumnName: String;
      CurrentWorkCycleStageIdColumnName: String;
      ResponsibleIdColumnName: String;
      IsSentToSigningColumnName: String;
      IsSelfRegisteredColumnName: String;
      
  end;

implementation

end.
