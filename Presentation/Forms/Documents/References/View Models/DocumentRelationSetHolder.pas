{ refactor: удалить, создать на основе AbstractDataSetHolder }
unit DocumentRelationSetHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  SysUtils,
  Classes;

type

  TDocumentRelationSetFieldDefs = class (TAbstractDataSetFieldDefs)

    public

      DocumentIdFieldName: String;
      DocumentKindIdFieldName: String;
      DocumentKindNameFieldName: String;
      DocumentNumberFieldName: String;
      DocumentDateFieldName: String;
      DocumentNameFieldName: String;

  end;
  
  TDocumentRelationSetHolder = class (TAbstractDataSetHolder)

    private

    protected

      function GetDocumentDateFieldName: String;
      function GetDocumentDateFieldValue: Variant;
      function GetDocumentIdFieldName: String;
      function GetDocumentIdFieldValue: Variant;
      function GetDocumentKindIdFieldName: String;
      function GetDocumentKindIdFieldValue: Variant;
      function GetDocumentKindNameFieldName: String;
      function GetDocumentKindNameFieldValue: String;
      function GetDocumentNameFieldName: String;
      function GetDocumentNameFieldValue: String;
      function GetDocumentNumberFieldName: String;
      function GetDocumentNumberFieldValue: String;
      function GetDocumentRelationSet: TDocumentRelationSetFieldDefs;

      procedure SetDocumentDateFieldName(const Value: String);
      procedure SetDocumentDateFieldValue(const Value: Variant);
      procedure SetDocumentIdFieldName(const Value: String);
      procedure SetDocumentIdFieldValue(const Value: Variant);
      procedure SetDocumentKindIdFieldName(const Value: String);
      procedure SetDocumentKindIdFieldValue(const Value: Variant);
      procedure SetDocumentKindNameFieldName(const Value: String);
      procedure SetDocumentKindNameFieldValue(const Value: String);
      procedure SetDocumentNameFieldName(const Value: String);
      procedure SetDocumentNameFieldValue(const Value: String);
      procedure SetDocumentNumberFieldName(const Value: String);
      procedure SetDocumentNumberFieldValue(const Value: String);

      procedure SetDocumentRelationSet(
        const Value: TDocumentRelationSetFieldDefs
      );

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public

      property DocumentIdFieldName: String
      read GetDocumentIdFieldName write SetDocumentIdFieldName;
      
      property DocumentKindIdFieldName: String
      read GetDocumentKindIdFieldName write SetDocumentKindIdFieldName;
      
      property DocumentKindNameFieldName: String
      read GetDocumentKindNameFieldName write SetDocumentKindNameFieldName;
      
      property DocumentNumberFieldName: String
      read GetDocumentNumberFieldName write SetDocumentNumberFieldName;
      
      property DocumentDateFieldName: String
      read GetDocumentDateFieldName write SetDocumentDateFieldName;
      
      property DocumentNameFieldName: String
      read GetDocumentNameFieldName write SetDocumentNameFieldName;

    public

      property DocumentIdFieldValue: Variant
      read GetDocumentIdFieldValue write SetDocumentIdFieldValue;
      
      property DocumentKindIdFieldValue: Variant
      read GetDocumentKindIdFieldValue write SetDocumentKindIdFieldValue;
      
      property DocumentKindNameFieldValue: String
      read GetDocumentKindNameFieldValue write SetDocumentKindNameFieldValue;
      
      property DocumentNumberFieldValue: String
      read GetDocumentNumberFieldValue write SetDocumentNumberFieldValue;
      
      property DocumentDateFieldValue: Variant
      read GetDocumentDateFieldValue write SetDocumentDateFieldValue;
      
      property DocumentNameFieldValue: String
      read GetDocumentNameFieldValue write SetDocumentNameFieldValue;

    public

      property FieldDefs: TDocumentRelationSetFieldDefs
      read GetDocumentRelationSet
      write SetDocumentRelationSet;
      
  end;

implementation

uses

  Variants;
  
{ TDocumentRelationSetHolder }

class function TDocumentRelationSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentRelationSetFieldDefs;
  
end;

function TDocumentRelationSetHolder.GetDocumentDateFieldName: String;
begin

  Result := FieldDefs.DocumentDateFieldName;

end;

function TDocumentRelationSetHolder.GetDocumentDateFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(DocumentDateFieldName, Null);
  
end;

function TDocumentRelationSetHolder.GetDocumentIdFieldName: String;
begin

  Result := FieldDefs.DocumentIdFieldName;
  
end;

function TDocumentRelationSetHolder.GetDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(DocumentIdFieldName, Null);
  
end;

function TDocumentRelationSetHolder.GetDocumentKindIdFieldName: String;
begin

  Result := FieldDefs.DocumentKindIdFieldName;
  
end;

function TDocumentRelationSetHolder.GetDocumentKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(DocumentKindIdFieldName, Null);

end;

function TDocumentRelationSetHolder.GetDocumentKindNameFieldName: String;
begin

  Result := FieldDefs.DocumentKindNameFieldName;

end;

function TDocumentRelationSetHolder.GetDocumentKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(DocumentKindNameFieldName, '');
  
end;

function TDocumentRelationSetHolder.GetDocumentNameFieldName: String;
begin

  Result := FieldDefs.DocumentNameFieldName;
  
end;

function TDocumentRelationSetHolder.GetDocumentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(DocumentNameFieldName, '');
  
end;

function TDocumentRelationSetHolder.GetDocumentNumberFieldName: String;
begin

  Result := FieldDefs.DocumentNumberFieldName;
  
end;

function TDocumentRelationSetHolder.GetDocumentNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(DocumentNumberFieldName, '');
  
end;

function TDocumentRelationSetHolder.GetDocumentRelationSet: TDocumentRelationSetFieldDefs;
begin

  Result := TDocumentRelationSetFieldDefs(inherited FieldDefs);
  
end;

procedure TDocumentRelationSetHolder.SetDocumentDateFieldName(
  const Value: String);
begin

  FieldDefs.DocumentDateFieldName := Value;
  
end;

procedure TDocumentRelationSetHolder.SetDocumentDateFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(DocumentDateFieldName, Value);
  
end;

procedure TDocumentRelationSetHolder.SetDocumentIdFieldName(
  const Value: String);
begin

  FieldDefs.DocumentIdFieldName := Value;
  
end;

procedure TDocumentRelationSetHolder.SetDocumentIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(DocumentIdFieldName, Value);
  
end;

procedure TDocumentRelationSetHolder.SetDocumentKindIdFieldName(
  const Value: String);
begin

  FieldDefs.DocumentKindIdFieldName := Value;
  
end;

procedure TDocumentRelationSetHolder.SetDocumentKindIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(DocumentKindIdFieldName, Value);

end;

procedure TDocumentRelationSetHolder.SetDocumentKindNameFieldName(
  const Value: String);
begin

  FieldDefs.DocumentKindNameFieldName := Value;
  
end;

procedure TDocumentRelationSetHolder.SetDocumentKindNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(DocumentKindNameFieldName, Value);
  
end;

procedure TDocumentRelationSetHolder.SetDocumentNameFieldName(
  const Value: String);
begin

  FieldDefs.DocumentNameFieldName := Value;
  
end;

procedure TDocumentRelationSetHolder.SetDocumentNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(DocumentNameFieldName, Value);
  
end;

procedure TDocumentRelationSetHolder.SetDocumentNumberFieldName(
  const Value: String);
begin

  FieldDefs.DocumentNumberFieldName := Value;
  
end;

procedure TDocumentRelationSetHolder.SetDocumentNumberFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(DocumentNumberFieldName, Value);
  
end;

procedure TDocumentRelationSetHolder.SetDocumentRelationSet(
  const Value: TDocumentRelationSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

end.

