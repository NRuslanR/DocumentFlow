unit DocumentChargeTableDef;

interface

uses

  TableDef;
  
const

  DOCUMENT_CHARGE_TABLE_NAME = 'doc.document_receivers';
  SERVICE_NOTE_CHARGE_TABLE_NAME = 'doc.service_note_receivers';

  DOCUMENT_CHARGE_TABLE_ALIAS_NAME = 'dr';
  
  DOCUMENT_CHARGE_TABLE_ID_FIELD = 'id';

  DOCUMENT_CHARGE_TABLE_KIND_ID_FIELD = 'kind_id';
  DOCUMENT_CHARGE_TABLE_CHARGE_FIELD = 'charge';
  DOCUMENT_CHARGE_TABLE_CHARGE_PERIOD_START_FIELD = 'charge_period_start';
  DOCUMENT_CHARGE_TABLE_CHARGE_PERIOD_END_FIELD = 'charge_period_end';
  DOCUMENT_CHARGE_TABLE_PERFORMER_ID_FIELD = 'performer_id';
  DOCUMENT_CHARGE_TABLE_PERFORMER_RESPONSE_FIELD = 'comment';
  DOCUMENT_CHARGE_TABLE_ACTUAL_PERFORMER_ID_FIELD = 'actual_performer_id';
  DOCUMENT_CHARGE_TABLE_ORIGINAL_DOCUMENT_ID_FIELD = 'document_id';
  DOCUMENT_CHARGE_TABLE_PERFORMING_DATE_FIELD = 'performing_date';
  DOCUMENT_CHARGE_TABLE_IS_FOR_ACQUAITANCE_FIELD = 'is_for_acquaitance';

type

  TDocumentChargeTableDef = class (TTableDef)

    public

      KindIdColumnName: String;
      ChargeColumnName: String;
      ChargePeriodStartColumnName: String;
      ChargePeriodEndColumnName: String;
      PerformerIdColumnName: String;
      PerformerResponseColumnName: String;
      ActualPerformerIdColumnName: String;
      OriginalDocumentIdColumnName: String;
      PerformingDateTimeColumnName: String;
      IsForAcquaitanceColumnName: String;
      
  end;
  
implementation

end.
