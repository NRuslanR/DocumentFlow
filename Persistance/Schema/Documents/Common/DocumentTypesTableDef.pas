unit DocumentTypesTableDef;

interface

uses

  TableDef;
  
const

  DOCUMENT_TYPES_TABLE_NAME = 'doc.document_types';

  DOCUMENT_TYPES_TABLE_ID_FIELD = 'id';
  DOCUMENT_TYPES_TABLE_NAME_FIELD = 'name';
  DOCUMENT_TYPES_TABLE_SHORT_NAME_FIELD = 'short_full_name';
  DOCUMENT_TYPES_TABLE_FULL_NAME_FIELD = 'single_full_name';
  DOCUMENT_TYPES_TABLE_DESCRIPTION_FIELD = 'description';
  DOCUMENT_TYPES_TABLE_PARENT_TYPE_ID = 'parent_type_id';
  DOCUMENT_TYPES_TABLE_IS_PRESENTED_FIELD = 'is_presented';
  DOCUMENT_TYPES_TABLE_IS_DOMAIN_FIELD = 'is_domain';
  DOCUMENT_TYPES_TABLE_SERVICE_NAME = 'service_name';

  SERVICE_NOTE_TYPE_ID_VALUE = 2;
  INCOMING_SERVICE_NOTE_TYPE_ID_VALUE = 3;
  APPROVEABLE_SERVICE_NOTE_TYPE_ID_VALUE = 4;
  INTERNAL_SERVICE_NOTE_TYPE_ID_VALUE = 5;
  OUTCOMING_INTERNAL_SERVICE_NOTE_TYPE_ID_VALUE = 6;
  INCOMING_INTERNAL_SERVICE_NOTE_TYPE_ID_VALUE = 7;

type

  TDocumentTypesTableDef = class (TTableDef)

    public

      NameColumnName: String;
      ShortFullNameColumnName: String;
      SingleFullNameColumnName: String;
      DescriptionColumnName: String;
      ParentTypeIdColumnName: String;
      IsPresentedColumnName: String;
      IsDomainColumnName: String;
      ServiceNameColumnName: String;

  end;

implementation

end.
