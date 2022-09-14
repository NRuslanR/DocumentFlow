unit DocumentSigningTableDef;

interface

uses

  TableDef;

const

  DOCUMENT_SIGNING_TABLE_NAME = 'doc.document_signings';

  DOCUMENT_SIGNING_TABLE_ID_FIELD = 'id';

  DOCUMENT_SIGNING_TABLE_SIGNER_ID_FIELD = 'signer_id';
  DOCUMENT_SIGNING_TABLE_ACTUAL_SIGNER_ID_FIELD = 'actual_signed_id';
  DOCUMENT_SIGNING_TABLE_DOCUMENT_ID_FIELD = 'document_id';
  DOCUMENT_SIGNING_TABLE_SIGNING_DATE_FIELD = 'signing_date';

type

  TDocumentSigningTableDef = class (TTableDef)

    public

      SignerIdColumnName: String;
      ActualSignerIdColumnName: String;
      DocumentIdColumnName: String;
      SigningDateColumnName: String;

  end;
  
implementation

end.
