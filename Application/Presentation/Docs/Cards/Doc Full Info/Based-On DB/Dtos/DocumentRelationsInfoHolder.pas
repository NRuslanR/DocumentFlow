unit DocumentRelationsInfoHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  SysUtils,
  Classes;

type

  TDocumentRelationsInfoFieldNames = class (TAbstractDataSetFieldDefs)

    public

      RelationIdFieldName: String;
      TargetDocumentIdFieldName: String;
      RelatedDocumentIdFieldName: String;
      RelatedDocumentKindIdFieldName: String;
      RelatedDocumentKindNameFieldName: String;
      RelatedDocumentNumberFieldName: String;
      RelatedDocumentNameFieldName: String;
      RelatedDocumentDateFieldName: String;
      
  end;

  TDocumentRelationsInfoHolder = class (TAbstractDataSetHolder)

    private

      function GetTargetDocumentIdFieldValue: Variant;
      function GetFieldNames: TDocumentRelationsInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentRelationsInfoFieldNames);

    protected

      function GetRelatedDocumentDateFieldValue: TDateTime;
      function GetRelationIdFieldValue: Variant;
      function GetRelatedDocumentIdFieldValue: Variant;
      function GetRelatedDocumentKindIdFieldValue: Variant;
      function GetRelatedDocumentKindNameFieldValue: String;
      function GetRelatedDocumentNameFieldValue: String;
      function GetRelatedDocumentNumberFieldValue: String;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    public

      property FieldNames: TDocumentRelationsInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property RelationIdFieldValue: Variant
      read GetRelationIdFieldValue;

      property TargetDocumentIdFieldValue: Variant
      read GetTargetDocumentIdFieldValue;
      
      property RelatedDocumentIdFieldValue: Variant
      read GetRelatedDocumentIdFieldValue;
      
      property RelatedDocumentKindIdFieldValue: Variant
      read GetRelatedDocumentKindIdFieldValue;
      
      property RelatedDocumentKindNameFieldValue: String
      read GetRelatedDocumentKindNameFieldValue;
      
      property RelatedDocumentNumberFieldValue: String
      read GetRelatedDocumentNumberFieldValue;

      property RelatedDocumentNameFieldValue: String
      read GetRelatedDocumentNameFieldValue;

      property RelatedDocumentDateFieldValue: TDateTime
      read GetRelatedDocumentDateFieldValue;

  end;

implementation

uses

  Variants;
{ TDocumentRelationsInfoHolder }

class function TDocumentRelationsInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentRelationsInfoFieldNames;
  
end;

function TDocumentRelationsInfoHolder.GetRelationIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.RelationIdFieldName, Null);

end;

function TDocumentRelationsInfoHolder.GetFieldNames: TDocumentRelationsInfoFieldNames;
begin

  Result := TDocumentRelationsInfoFieldNames(inherited FieldDefs);
  
end;

function TDocumentRelationsInfoHolder.GetRelatedDocumentDateFieldValue: TDateTime;
begin

  Result := GetDataSetFieldValue(FieldNames.RelatedDocumentDateFieldName, 0);

end;

function TDocumentRelationsInfoHolder.GetRelatedDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.RelatedDocumentIdFieldName, Null);
  
end;

function TDocumentRelationsInfoHolder.GetRelatedDocumentKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.RelatedDocumentKindIdFieldName, Null);
  
end;

function TDocumentRelationsInfoHolder.GetRelatedDocumentKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.RelatedDocumentKindNameFieldName, '');
  
end;

function TDocumentRelationsInfoHolder.GetRelatedDocumentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.RelatedDocumentNameFieldName, '');
  
end;

function TDocumentRelationsInfoHolder.GetRelatedDocumentNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.RelatedDocumentNumberFieldName, '');
  
end;

function TDocumentRelationsInfoHolder.GetTargetDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.TargetDocumentIdFieldName, Null);
  
end;

procedure TDocumentRelationsInfoHolder.SetFieldNames(
  const Value: TDocumentRelationsInfoFieldNames);
begin

  inherited FieldDefs := Value;
  
end;

end.
