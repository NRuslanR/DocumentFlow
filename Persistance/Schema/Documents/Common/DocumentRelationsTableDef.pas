unit DocumentRelationsTableDef;

interface

uses

  TableDef;

const

  DOCUMENT_RELATIONS_TABLE_NAME = 'doc.service_note_links';

  DOCUMENT_RELATIONS_TABLE_ID_FIELD = 'id';
  DOCUMENT_RELATIONS_TABLE_TARGET_DOCUMENT_ID_FIELD = 'document_id';
  DOCUMENT_RELATIONS_TABLE_RELATED_DOCUMENT_ID_FIELD = 'related_document_id';
  DOCUMENT_RELATIONS_TABLE_RELATED_DOCUMENT_TYPE_ID_FIELD = 'related_document_type_id';

type

  TDocumentRelationsTableDef = class (TTableDef)

    public

      TargetDocumentIdColumnName: String;
      RelatedDocumentIdColumnName: String;
      RelatedDocumentTypeIdColumnName: String;

  end;

implementation

end.
