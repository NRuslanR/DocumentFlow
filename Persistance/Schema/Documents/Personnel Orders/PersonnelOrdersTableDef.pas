unit PersonnelOrdersTableDef;

interface

uses

  DocumentTableDef,
  TableDef;
  
const

  PERSONNEL_ORDERS_TABLE_NAME = 'doc.personnel_orders';

  PERSONNEL_ORDERS_TABLE_ID_FIELD = 'id';
  PERSONNEL_ORDERS_TABLE_TYPE_ID_FIELD = 'type_id';
  PERSONNEL_ORDERS_TABLE_SUB_TYPE_ID_FIELD = 'sub_type_id';
  PERSONNEL_ORDERS_TABLE_NAME_FIELD = 'name';
  PERSONNEL_ORDERS_TABLE_NUMBER_FIELD = 'document_number';
  PERSONNEL_ORDERS_TABLE_CREATION_DATE_FIELD = 'creation_date';
  PERSONNEL_ORDERS_TABLE_NOTE_FIELD = 'note';
  PERSONNEL_ORDERS_TABLE_CURRENT_WORK_CYCLE_STAGE_ID = 'current_work_cycle_stage_id';
  PERSONNEL_ORDERS_TABLE_CONTENT_FIELD = 'content';
  PERSONNEL_ORDERS_TABLE_AUTHOR_ID_FIELD = 'author_id';
  PERSONNEL_ORDERS_TABLE_PERFORMER_ID_FIELD = 'performer_id';
  PERSONNEL_ORDERS_TABLE_IS_SENT_TO_SIGNING_FIELD = 'is_sent_to_signing';

type

  TPersonnelOrdersTableDef = class (TDocumentTableDef)

    public

      SubKindIdColumnName: String;
      
  end;

implementation

end.
