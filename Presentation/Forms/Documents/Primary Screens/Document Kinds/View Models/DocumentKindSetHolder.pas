unit DocumentKindSetHolder;

interface

uses

  AbstractDataSetHolder,
  DB,
  SysUtils,
  Classes;

type

  TDocumentKindSetFieldDefs = class (TAbstractDataSetFieldDefs)

    protected

      function GetDocumentKindIdFieldName: String;
      procedure SetDocumentKindIdFieldName(const Value: String);

    public

      TopLevelDocumentKindIdFieldName: String;
      DocumentKindNameFieldName: String;
      OriginalDocumentKindNameFieldName: String;

    public

      property DocumentKindIdFieldName: String
      read GetDocumentKindIdFieldName write SetDocumentKindIdFieldName;

  end;

  TDocumentKindSetHolder = class (TAbstractDataSetHolder)

    private

      function GetDocumentKindIdFieldName: String;
      function GetDocumentKindIdFieldValue: Variant;
      function GetDocumentKindNameFieldName: String;
      function GetDocumentKindNameFieldValue: String;
      function GetocumentKindSetFieldDefs: TDocumentKindSetFieldDefs;
      function GetTopLevelDocumentKindIdFieldName: String;
      function GetTopLevelDocumentKindIdFieldValue: Variant;
      function GetOriginalDocumentKindNameFieldName: String;
      function GetOriginalDocumentKindNameFieldValue: String;

      procedure SetocumentKindSetFieldDefs(
        const Value: TDocumentKindSetFieldDefs
      );
      
      procedure SetTopLevelDocumentKindIdFieldName(const Value: String);
      procedure SetTopLevelDocumentKindIdFieldValue(const Value: Variant);
      procedure SetOriginalDocumentKindNameFieldName(const Value: String);
      procedure SetOriginalDocumentKindNameFieldValue(const Value: String);
      procedure SetDocumentKindIdFieldName(const Value: String);
      procedure SetDocumentKindIdFieldValue(const Value: Variant);
      procedure SetDocumentKindNameFieldName(const Value: String);
      procedure SetDocumentKindNameFieldValue(const Value: String);

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public

      function LocateByDocumentKindId(const DocumentKindId: Variant; const Options: TLocateOptions = []): Boolean;

    public

      property DocumentKindIdFieldName: String
      read GetDocumentKindIdFieldName write SetDocumentKindIdFieldName;
      
      property TopLevelDocumentKindIdFieldName: String
      read GetTopLevelDocumentKindIdFieldName
      write SetTopLevelDocumentKindIdFieldName;

      property DocumentKindNameFieldName: String
      read GetDocumentKindNameFieldName
      write SetDocumentKindNameFieldName;

      property OriginalDocumentKindNameFieldName: String
      read GetOriginalDocumentKindNameFieldName
      write SetOriginalDocumentKindNameFieldName;

    public

      property DocumentKindIdFieldValue: Variant
      read GetDocumentKindIdFieldValue write SetDocumentKindIdFieldValue;
      
      property TopLevelDocumentKindIdFieldValue: Variant
      read GetTopLevelDocumentKindIdFieldValue
      write SetTopLevelDocumentKindIdFieldValue;

      property DocumentKindNameFieldValue: String
      read GetDocumentKindNameFieldValue
      write SetDocumentKindNameFieldValue;

      property OriginalDocumentKindNameFieldValue: String
      read GetOriginalDocumentKindNameFieldValue
      write SetOriginalDocumentKindNameFieldValue;

    public

      property FieldDefs: TDocumentKindSetFieldDefs
      read GetocumentKindSetFieldDefs write SetocumentKindSetFieldDefs;

    public

      constructor CreateFrom(DataSet: TDataSet; FieldDefs: TDocumentKindSetFieldDefs);

  end;

implementation

uses

  Variants;
  
{ TDocumentKindSetFieldDefs }

function TDocumentKindSetFieldDefs.GetDocumentKindIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

procedure TDocumentKindSetFieldDefs.SetDocumentKindIdFieldName(
  const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

{ TDocumentKindSetHolder }

constructor TDocumentKindSetHolder.CreateFrom(
  DataSet: TDataSet;
  FieldDefs: TDocumentKindSetFieldDefs
);
begin

  inherited CreateFrom(DataSet, FieldDefs);
  
end;

class function TDocumentKindSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentKindSetFieldDefs;
  
end;

function TDocumentKindSetHolder.GetDocumentKindIdFieldName: String;
begin

  Result := FieldDefs.DocumentKindIdFieldName;

end;

function TDocumentKindSetHolder.GetDocumentKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(DocumentKindIdFieldName, Null);
  
end;

function TDocumentKindSetHolder.GetDocumentKindNameFieldName: String;
begin

  Result := FieldDefs.DocumentKindNameFieldName;

end;

function TDocumentKindSetHolder.GetDocumentKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(DocumentKindNameFieldName, '');

end;

function TDocumentKindSetHolder.GetocumentKindSetFieldDefs: TDocumentKindSetFieldDefs;
begin

  Result := TDocumentKindSetFieldDefs(inherited FieldDefs);

end;

function TDocumentKindSetHolder.GetOriginalDocumentKindNameFieldName: String;
begin

  Result := FieldDefs.OriginalDocumentKindNameFieldName;

end;

function TDocumentKindSetHolder.GetOriginalDocumentKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(OriginalDocumentKindNameFieldName, '');
  
end;

function TDocumentKindSetHolder.GetTopLevelDocumentKindIdFieldName: String;
begin

  Result := FieldDefs.TopLevelDocumentKindIdFieldName;

end;

function TDocumentKindSetHolder.GetTopLevelDocumentKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(TopLevelDocumentKindIdFieldName, Null);

end;

function TDocumentKindSetHolder.LocateByDocumentKindId(
  const DocumentKindId: Variant;
  const Options: TLocateOptions
): Boolean;
begin

  Result := LocateByRecordId(DocumentKindId, Options);

end;

procedure TDocumentKindSetHolder.SetDocumentKindIdFieldName(
  const Value: String);
begin

  FieldDefs.DocumentKindIdFieldName := Value;
  
end;

procedure TDocumentKindSetHolder.SetDocumentKindIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(DocumentKindIdFieldName, Value);

end;

procedure TDocumentKindSetHolder.SetDocumentKindNameFieldName(
  const Value: String);
begin

  FieldDefs.DocumentKindNameFieldName := Value;
  
end;

procedure TDocumentKindSetHolder.SetDocumentKindNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(DocumentKindNameFieldName, Value);
  
end;

procedure TDocumentKindSetHolder.SetocumentKindSetFieldDefs(
  const Value: TDocumentKindSetFieldDefs);
begin

  SetFieldDefs(Value);

end;

procedure TDocumentKindSetHolder.SetOriginalDocumentKindNameFieldName(
  const Value: String);
begin

  FieldDefs.OriginalDocumentKindNameFieldName := Value;

end;

procedure TDocumentKindSetHolder.SetOriginalDocumentKindNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(OriginalDocumentKindNameFieldName, Value);
  
end;

procedure TDocumentKindSetHolder.SetTopLevelDocumentKindIdFieldName(
  const Value: String);
begin

  FieldDefs.TopLevelDocumentKindIdFieldName := Value;
  
end;

procedure TDocumentKindSetHolder.SetTopLevelDocumentKindIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(TopLevelDocumentKindIdFieldName, Value);

end;

end.
