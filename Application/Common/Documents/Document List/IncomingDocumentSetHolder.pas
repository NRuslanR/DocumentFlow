unit IncomingDocumentSetHolder;

interface

uses

  DocumentSetHolder,
  AbstractDocumentSetHolderDecorator,
  AbstractDataSetHolder,
  SysUtils;

type

  TIncomingDocumentSetFieldDefs = class (TAbstractDocumentSetFieldDefsDecorator)

    public

      IncomingNumberFieldName: String;
      ReceiptDateFieldName: String;
      SendingDepartmentNameFieldName: String;

  end;

  TIncomingDocumentSetHolder = class (TAbstractDocumentSetHolderDecorator)

    protected

      FRespondingDocumentCreatingAllowed: Boolean;
      
      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    protected

      function GetIncomingDocumentSetFieldDefs: TIncomingDocumentSetFieldDefs;
      function GetIncomingNumberFieldName: String;
      function GetIncomingNumberFieldValue: String;
      function GetReceiptDateFieldName: String;
      function GetReceiptDateFieldValue: TDateTime;
      function GetSendingDepartmentNameFieldName: String;
      function GetSendingDepartmentNameFieldValue: String;

      procedure SetIncomingDocumentSetFieldDefs(
        const Value: TIncomingDocumentSetFieldDefs
      );

      procedure SetIncomingNumberFieldName(const Value: String);
      procedure SetIncomingNumberFieldValue(const Value: String);
      procedure SetReceiptDateFieldName(const Value: String);
      procedure SetReceiptDateFieldValue(const Value: TDateTime);
      procedure SetSendingDepartmentNameFieldName(const Value: String);
      procedure SetSendingDepartmentNameFieldValue(const Value: String);

    public

      property IncomingNumberFieldName: String
      read GetIncomingNumberFieldName write SetIncomingNumberFieldName;
      
      property ReceiptDateFieldName: String
      read GetReceiptDateFieldName write SetReceiptDateFieldName;

      property SendingDepartmentNameFieldName: String
      read GetSendingDepartmentNameFieldName
      write SetSendingDepartmentNameFieldName;
      
    public

      property IncomingNumberFieldValue: String
      read GetIncomingNumberFieldValue write SetIncomingNumberFieldValue;

      property ReceiptDateFieldValue: TDateTime
      read GetReceiptDateFieldValue write SetReceiptDateFieldValue;

      property SendingDepartmentNameFieldValue: String
      read GetSendingDepartmentNameFieldValue
      write SetSendingDepartmentNameFieldValue;

    public

      property RespondingDocumentCreatingAllowed: Boolean
      read FRespondingDocumentCreatingAllowed
      write FRespondingDocumentCreatingAllowed;
      
    public

      property FieldDefs: TIncomingDocumentSetFieldDefs
      read GetIncomingDocumentSetFieldDefs
      write SetIncomingDocumentSetFieldDefs;

  end;
  
implementation

{ TIncomingDocumentSetHolder }

class function TIncomingDocumentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TIncomingDocumentSetFieldDefs;
  
end;

function TIncomingDocumentSetHolder.GetIncomingDocumentSetFieldDefs: TIncomingDocumentSetFieldDefs;
begin

  Result := TIncomingDocumentSetFieldDefs(inherited FieldDefs);

end;

function TIncomingDocumentSetHolder.GetIncomingNumberFieldName: String;
begin

  Result := FieldDefs.IncomingNumberFieldName;

end;

function TIncomingDocumentSetHolder.GetIncomingNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(IncomingNumberFieldName, '');
  
end;

function TIncomingDocumentSetHolder.GetReceiptDateFieldName: String;
begin

  Result := FieldDefs.ReceiptDateFieldName;

end;

function TIncomingDocumentSetHolder.GetReceiptDateFieldValue: TDateTime;
begin

  Result := GetDataSetFieldValue(ReceiptDateFieldName, 0);
  
end;

function TIncomingDocumentSetHolder.GetSendingDepartmentNameFieldName: String;
begin

  Result := FieldDefs.SendingDepartmentNameFieldName;

end;

function TIncomingDocumentSetHolder.GetSendingDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(SendingDepartmentNameFieldName, '');
  
end;

procedure TIncomingDocumentSetHolder.SetIncomingDocumentSetFieldDefs(
  const Value: TIncomingDocumentSetFieldDefs);
begin

  SetFieldDefs(Value);
  
end;

procedure TIncomingDocumentSetHolder.SetIncomingNumberFieldName(
  const Value: String);
begin

  FieldDefs.IncomingNumberFieldName := Value;

end;

procedure TIncomingDocumentSetHolder.SetIncomingNumberFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(IncomingNumberFieldName, Value);
  
end;

procedure TIncomingDocumentSetHolder.SetReceiptDateFieldName(
  const Value: String);
begin

  FieldDefs.ReceiptDateFieldName := Value;

end;

procedure TIncomingDocumentSetHolder.SetReceiptDateFieldValue(
  const Value: TDateTime);
begin

  SetDataSetFieldValue(ReceiptDateFieldName, Value);
  
end;

procedure TIncomingDocumentSetHolder.SetSendingDepartmentNameFieldName(
  const Value: String);
begin

  FieldDefs.SendingDepartmentNameFieldName := Value;
  
end;

procedure TIncomingDocumentSetHolder.SetSendingDepartmentNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(SendingDepartmentNameFieldName, Value);
  
end;

end.
