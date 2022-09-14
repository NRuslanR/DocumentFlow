unit IncomingDocumentInfoHolder;

interface

uses

  DocumentInfoHolder,
  AbstractDataSetHolder,
  DB,
  Disposable,
  SysUtils;

type

  TIncomingDocumentInfoFieldNames = class (TDocumentInfoFieldNames)

    public

      IncomingDocumentIdFieldName: String;
      IncomingDocumentKindIdFieldName: String;
      IncomingDocumentKindNameFieldName: String;
      IncomingNumberFieldName: String;
      ReceiptDateFieldName: String;
      IncomingDocumentStageNumberFieldName: String;
      IncomingDocumentStageNameFieldName: String;

    private

      FOriginalDocumentInfoFieldNames: TDocumentInfoFieldNames;
      FFreeOriginalDocumentInfoFieldNames: IDisposable;
      
      function GetOriginalDocumentInfoFieldNames: TDocumentInfoFieldNames;
      procedure SetOriginalDocumentInfoFieldNames(const Value: TDocumentInfoFieldNames);
      
    public

      constructor Create;

      property OriginalDocumentInfoFieldNames: TDocumentInfoFieldNames
      read GetOriginalDocumentInfoFieldNames write SetOriginalDocumentInfoFieldNames;
    
  end;
  
  TIncomingDocumentInfoHolder = class (TDocumentInfoHolder)

    private
    procedure SetIncomingDocumentFieldNames(
      const Value: TIncomingDocumentInfoFieldNames);
    
    protected

      FDocumentInfoHolder: TDocumentInfoHolder;
      FFreeDocumentInfoHolder: IDisposable;
      
    protected

      function GetFieldNames: TIncomingDocumentInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentInfoFieldNames); override;
      
      function GetIncomingNumberFieldValue: String;
      function GetReceiptDateFieldValue: TDateTime;

      function GetIncomingDocumentIdFieldValue: Variant;
      function GetIncomingDocumentKindIdFieldValue: Variant;
      function GetIncomingDocumentKindNameFieldValue: String;
      function GetIncomingDocumentStageNameFieldValue: String;
      function GetIncomingDocumentStageNumberFieldValue: Integer;

      procedure SetDocumentInfoHolder(const Value: TDocumentInfoHolder);

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

      procedure SetDataSet(const Value: TDataSet); override;
      
    public

      constructor Create; overload; override;
      constructor CreateFrom(DataSet: TDataSet); overload; override;
      constructor CreateFrom(DataSet: TDataSet; FieldDefs: TAbstractDataSetFieldDefs); overload; override;
      
      constructor Create(OriginalDocumentInfoHolder: TDocumentInfoHolder); overload;
      
      property FieldNames: TIncomingDocumentInfoFieldNames
      read GetFieldNames write SetIncomingDocumentFieldNames;

      property OriginalDocumentInfoHolder: TDocumentInfoHolder
      read FDocumentInfoHolder write SetDocumentInfoHolder;

      property IncomingNumberFieldValue: String
      read GetIncomingNumberFieldValue;

      property ReceiptDateFieldValue: TDateTime
      read GetReceiptDateFieldValue;

      property IncomingDocumentIdFieldValue: Variant
      read GetIncomingDocumentIdFieldValue;

      property IncomingDocumentKindIdFieldValue: Variant
      read GetIncomingDocumentKindIdFieldValue;

      property IncomingDocumentKindNameFieldValue: String
      read GetIncomingDocumentKindNameFieldValue;

      property IncomingDocumentStageNumberFieldValue: Integer
      read GetIncomingDocumentStageNumberFieldValue;

      property IncomingDocumentStageNameFieldValue: String
      read GetIncomingDocumentStageNameFieldValue;

  end;

implementation

uses

  Variants;

constructor TIncomingDocumentInfoHolder.Create(
  OriginalDocumentInfoHolder: TDocumentInfoHolder);
begin

  inherited Create;
                                               
  Self.OriginalDocumentInfoHolder := OriginalDocumentInfoHolder;

end;

constructor TIncomingDocumentInfoHolder.Create;
begin

  inherited;

end;

constructor TIncomingDocumentInfoHolder.CreateFrom(DataSet: TDataSet);
begin

  inherited;

end;

constructor TIncomingDocumentInfoHolder.CreateFrom(DataSet: TDataSet;
  FieldDefs: TAbstractDataSetFieldDefs);
begin
  inherited;

end;

class function TIncomingDocumentInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TIncomingDocumentInfoFieldNames;
  
end;

function TIncomingDocumentInfoHolder.GetFieldNames:
  TIncomingDocumentInfoFieldNames;
begin

  Result := TIncomingDocumentInfoFieldNames(inherited FieldNames);
  
end;

function TIncomingDocumentInfoHolder.
  GetIncomingDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IncomingDocumentIdFieldName,
              Null
            );
            
end;

function TIncomingDocumentInfoHolder.GetIncomingDocumentKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IncomingDocumentKindIdFieldName,
              Null
            );
            
end;

function TIncomingDocumentInfoHolder.GetIncomingDocumentKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IncomingDocumentKindNameFieldName,
              ''
            );
            
end;

function TIncomingDocumentInfoHolder.GetIncomingDocumentStageNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IncomingDocumentStageNameFieldName,
              ''
            );

end;

function TIncomingDocumentInfoHolder.GetIncomingDocumentStageNumberFieldValue: Integer;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IncomingDocumentStageNumberFieldName,
              Null
            );
            
end;

function TIncomingDocumentInfoHolder.GetIncomingNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IncomingNumberFieldName,
              ''
            );
            
end;

function TIncomingDocumentInfoHolder.GetReceiptDateFieldValue: TDateTime;
begin

  Result := GetDataSetFieldValue(
              Fieldnames.ReceiptDateFieldName,
              0
            );

end;

procedure TIncomingDocumentInfoHolder.SetDataSet(const Value: TDataSet);
begin

  inherited SetDataSet(Value);

  OriginalDocumentInfoHolder.DataSet := Value;
  
end;

procedure TIncomingDocumentInfoHolder.SetDocumentInfoHolder(
  const Value: TDocumentInfoHolder);
begin

  if FDocumentInfoHolder = Value then Exit;

  FDocumentInfoHolder := Value;
  FFreeDocumentInfoHolder := FDocumentInfoHolder;

  if Assigned(FieldNames) then
    FieldNames.OriginalDocumentInfoFieldNames := Value.FieldNames;

end;

procedure TIncomingDocumentInfoHolder.SetFieldNames(
  const Value: TDocumentInfoFieldNames);
begin

  inherited SetFieldNames(Value as TIncomingDocumentInfoFieldNames);

  if Assigned(OriginalDocumentInfoHolder) then begin

    OriginalDocumentInfoHolder.FieldNames :=
      TIncomingDocumentInfoFieldNames(Value).OriginalDocumentInfoFieldNames;
      
  end;

end;

procedure TIncomingDocumentInfoHolder.SetIncomingDocumentFieldNames(
  const Value: TIncomingDocumentInfoFieldNames);
begin

  SetFieldNames(Value);

end;

{ TIncomingDocumentInfoFieldNames }

constructor TIncomingDocumentInfoFieldNames.Create;
begin

  inherited Create;

end;

function TIncomingDocumentInfoFieldNames.GetOriginalDocumentInfoFieldNames: TDocumentInfoFieldNames;
begin

  Result := FOriginalDocumentInfoFieldNames;

end;

procedure TIncomingDocumentInfoFieldNames.SetOriginalDocumentInfoFieldNames(
  const Value: TDocumentInfoFieldNames);
begin

  FOriginalDocumentInfoFieldNames := Value;
  FFreeOriginalDocumentInfoFieldNames := FOriginalDocumentInfoFieldNames;

end;

end.
