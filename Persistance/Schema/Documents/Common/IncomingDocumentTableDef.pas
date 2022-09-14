unit IncomingDocumentTableDef;

interface

uses

  TableDef;
  
const

  INCOMING_DOCUMENT_TABLE_NAME = 'doc.document_receivers';

  INCOMING_DOCUMENT_TABLE_ID_FIELD = 'id';
  INCOMING_DOCUMENT_TABLE_TYPE_ID_FIELD = 'incoming_document_type_id';
  INCOMING_DOCUMENT_TABLE_ALIAS_ID_FIELD = 'incoming_document_id';
  
  INCOMING_DOCUMENT_TABLE_NUMBER_FIELD = 'input_number';
  INCOMING_DOCUMENT_TABLE_RECEIPT_DATE_FIELD = 'input_number_date';
  INCOMING_DOCUMENT_TABLE_RECEIVER_ID_FIELD = 'performer_id';
  INCOMING_DOCUMENT_TABLE_ORIGINAL_DOCUMENT_ID_FIELD = 'document_id';

type

  TIncomingDocumentTableDef = class (TTableDef)

    public

      TypeIdColumnName: String;
      NumberColumnName: String;
      ReceiptDateColumnName: String;
      ReceiverIdColumnName: String;
      OriginalDocumentIdColumnName: String;
      
  end;

implementation

end.
