unit NotPerformedIncomingDocumentsReportData;

interface

uses

  AbstractDataSetHolder,
  NotPerformedDocumentsReportData,
  SysUtils;

type

  TNotPerformedIncomingDocumentSetFieldDefs = class (TNotPerformedDocumentSetFieldDefs)

    public

      IncomingNumberFieldName: String;
      ReceiptDateFieldName: String;
      
  end;
  
  TNotPerformedIncomingDocumentSetHolder = class (TNotPerformedDocumentSetHolder)

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    protected

      function GetIncomingNumberFieldName: String;
      function GetIncomingNumberFieldValue: String;
      function GetNotPerformedIncomingDocumentSetFieldDefs: TNotPerformedIncomingDocumentSetFieldDefs;
      function GetReceiptDateFieldName: String;
      function GetReceiptDateFieldValue: TDateTime;

      procedure SetIncomingNumberFieldName(const Value: String);
      procedure SetIncomingNumberFieldValue(const Value: String);

      procedure SetNotPerformedIncomingDocumentSetFieldDefs(
        const Value: TNotPerformedIncomingDocumentSetFieldDefs);

      procedure SetReceiptDateFieldName(const Value: String);
      procedure SetReceiptDateFieldValue(const Value: TDateTime);

    public

       property IncomingNumberFieldName: String
       read GetIncomingNumberFieldName  write SetIncomingNumberFieldName;

       property ReceiptDateFieldName: String
       read GetReceiptDateFieldName write SetReceiptDateFieldName;

    public

      property IncomingNumberFieldValue: String
      read GetIncomingNumberFieldValue  write SetIncomingNumberFieldValue;

      property ReceiptDateFieldValue: TDateTime
      read GetReceiptDateFieldValue write SetReceiptDateFieldValue;

    public

      property FieldDefs: TNotPerformedIncomingDocumentSetFieldDefs
      read GetNotPerformedIncomingDocumentSetFieldDefs
      write SetNotPerformedIncomingDocumentSetFieldDefs;

  end;

implementation

{ TNotPerformedIncomingDocumentSetHolder }

class function TNotPerformedIncomingDocumentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TNotPerformedIncomingDocumentSetFieldDefs;
  
end;

function TNotPerformedIncomingDocumentSetHolder.GetIncomingNumberFieldName: String;
begin

  Result := FieldDefs.IncomingNumberFieldName;

end;

function TNotPerformedIncomingDocumentSetHolder.GetIncomingNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(IncomingNumberFieldName, '');

end;

function TNotPerformedIncomingDocumentSetHolder.
  GetNotPerformedIncomingDocumentSetFieldDefs: TNotPerformedIncomingDocumentSetFieldDefs;
begin

  Result := TNotPerformedIncomingDocumentSetFieldDefs(inherited FieldDefs);
  
end;

function TNotPerformedIncomingDocumentSetHolder.GetReceiptDateFieldName: String;
begin

  Result := FieldDefs.ReceiptDateFieldName;
  
end;

function TNotPerformedIncomingDocumentSetHolder.GetReceiptDateFieldValue: TDateTime;
begin

  Result := GetDataSetFieldValue(ReceiptDateFieldName, 0);
  
end;

procedure TNotPerformedIncomingDocumentSetHolder.SetIncomingNumberFieldName(
  const Value: String);
begin

  FieldDefs.IncomingNumberFieldName := Value;
  
end;

procedure TNotPerformedIncomingDocumentSetHolder.SetIncomingNumberFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(IncomingNumberFieldName, Value);

end;

procedure TNotPerformedIncomingDocumentSetHolder.SetNotPerformedIncomingDocumentSetFieldDefs(
  const Value: TNotPerformedIncomingDocumentSetFieldDefs);
begin

  inherited FieldDefs := Value;

end;

procedure TNotPerformedIncomingDocumentSetHolder.SetReceiptDateFieldName(
  const Value: String);
begin

  FieldDefs.RecordIdFieldName := Value;
  
end;

procedure TNotPerformedIncomingDocumentSetHolder.SetReceiptDateFieldValue(
  const Value: TDateTime);
begin

  SetDataSetFieldValue(ReceiptDateFieldName, Value);
  
end;

end.
