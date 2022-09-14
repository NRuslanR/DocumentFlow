unit DocumentChargeSheetTableDef;

interface

uses

  DocumentChargeTableDef;

const

  DOCUMENT_CHARGE_SHEET_TABLE_NAME = 'doc.document_receivers';

  DOCUMENT_CHARGE_SHEET_TABLE_ID_FIELD = 'id';

  DOCUMENT_CHARGE_SHEET_TABLE_KIND_ID_FIELD = 'kind_id';
  DOCUMENT_CHARGE_SHEET_TABLE_ISSUER_ID_FIELD = 'issuer_id';
  DOCUMENT_CHARGE_SHEET_TABLE_CHARGE_FIELD = 'charge';
  DOCUMENT_CHARGE_SHEET_TABLE_CHARGE_PERIOD_START_FIELD = 'charge_period_start';
  DOCUMENT_CHARGE_SHEET_TABLE_CHARGE_PERIOD_END_FIELD = 'charge_period_end';
  DOCUMENT_CHARGE_SHEET_TABLE_PERFORMER_ID_FIELD = 'performer_id';
  DOCUMENT_CHARGE_SHEET_TABLE_PERFORMER_RESPONSE_FIELD = 'comment';
  DOCUMENT_CHARGE_SHEET_TABLE_ACTUAL_PERFORMER_ID_FIELD = 'actual_performer_id';
  DOCUMENT_CHARGE_SHEET_TABLE_HEAD_CHARGE_SHEET_ID_FIELD = 'head_charge_sheet_id';
  DOCUMENT_CHARGE_SHEET_TABLE_ORIGINAL_DOCUMENT_ID_FIELD = 'document_id';
  DOCUMENT_CHARGE_SHEET_TABLE_TOP_LEVEL_CHARGE_SHEET_ID_FIELD = 'top_level_charge_sheet_id';
  DOCUMENT_CHARGE_SHEET_TABLE_PERFORMING_DATE_FIELD = 'performing_date';
  DOCUMENT_CHARGE_SHEET_TABLE_ISSUING_DATETIME_FIELD = 'issuing_datetime';
  DOCUMENT_CHARGE_SHEET_TABLE_IS_FOR_ACQUAITANCE_FIELD = 'is_for_acquaitance';

type

  TDocumentChargeSheetTableDef = class (TDocumentChargeTableDef)

    public

      IssuerIdColumnName: String;
      HeadChargeSheetIdColumnName: String;
      TopLevelChargeSheetIdColumnName: String;
      IssuingDateTimeColumnName: String;
      DocumentKindIdColumnName: String;

  end;

implementation

end.
