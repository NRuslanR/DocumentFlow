unit PersonnelOrderInfoHolder;

interface

uses

  AbstractDataSetHolder,
  DocumentInfoHolder,
  DocumentFullInfoDataSetHolder,
  SysUtils;

type

  TPersonnelOrdeInfoFieldNames = class (TDocumentInfoFieldNames)

    public

      SubKindIdFieldName: String;
      SubKindNameFieldName: String;

  end;

  TPersonnelOrderInfoHolder = class (TDocumentInfoHolder)

    private

      function GetSubKindIdFieldValue: Variant;
      function GetSubKindNameFieldValue: String;

      procedure SetSubKindIdFieldValue(const Value: Variant);
      procedure SetSubKindNameFieldValue(const Value: String);

      function GetPersonnelOrdeInfoFieldNames: TPersonnelOrdeInfoFieldNames;

      procedure SetPersonnelOrdeInfoFieldNames(
        const Value: TPersonnelOrdeInfoFieldNames
      );

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    public

      property SubKindIdFieldValue: Variant
      read GetSubKindIdFieldValue write SetSubKindIdFieldValue;

      property SubKindNameFieldValue: String
      read GetSubKindNameFieldValue write SetSubKindNameFieldValue;

    public

      property FieldNames: TPersonnelOrdeInfoFieldNames
      read GetPersonnelOrdeInfoFieldNames
      write SetPersonnelOrdeInfoFieldNames;
      
  end;

implementation

uses

  Variants;

{ TPersonnelOrderInfoHolder }

class function TPersonnelOrderInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TPersonnelOrdeInfoFieldNames;
  
end;

function TPersonnelOrderInfoHolder.GetPersonnelOrdeInfoFieldNames: TPersonnelOrdeInfoFieldNames;
begin

  Result := TPersonnelOrdeInfoFieldNames(inherited FieldNames);
  
end;

function TPersonnelOrderInfoHolder.GetSubKindIdFieldValue: Variant;
begin


  Result := GetDataSetFieldValue(FieldNames.SubKindIdFieldName, Null);

end;

function TPersonnelOrderInfoHolder.GetSubKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.SubKindNameFieldName, '');
  
end;

procedure TPersonnelOrderInfoHolder.SetPersonnelOrdeInfoFieldNames(
  const Value: TPersonnelOrdeInfoFieldNames);
begin

  inherited FieldNames := Value;

end;

procedure TPersonnelOrderInfoHolder.SetSubKindIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(FieldNames.SubKindIdFieldName, Value);
  
end;

procedure TPersonnelOrderInfoHolder.SetSubKindNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(FieldNames.SubKindNameFieldName, Value);
  
end;

end.
