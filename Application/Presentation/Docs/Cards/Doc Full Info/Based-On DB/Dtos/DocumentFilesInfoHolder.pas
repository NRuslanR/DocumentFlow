unit DocumentFilesInfoHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  SysUtils,
  Classes;

type

  TDocumentFilesInfoFieldNames = class (TAbstractDataSetFieldDefs)

    public

      IdFieldName: String;
      NameFieldName: String;
      PathFieldName: String;
      DocumentIdFieldName: String;
      
  end;

  TDocumentFilesInfoHolder = class (TAbstractDataSetHolder)

    private

      function GetDocumentIdFieldValue: Variant;
      function GetIdFieldValue: Variant;
      function GetNameFieldValue: String;
      function GetPathFieldValue: String;
      function GetFieldNames: TDocumentFilesInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentFilesInfoFieldNames);

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public

      property FieldNames: TDocumentFilesInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property DocumentIdFieldValue: Variant
      read GetDocumentIdFieldValue;
      
      property IdFieldValue: Variant
      read GetIdFieldValue;

      property NameFieldValue: String
      read GetNameFieldValue;

      property PathFieldValue: String
      read GetPathFieldValue;

  end;

implementation

uses

  Variants;

{ TDocumentFilesInfoHolder }

class function TDocumentFilesInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentFilesInfoFieldNames;
  
end;

function TDocumentFilesInfoHolder.GetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.IdFieldName, Null);
  
end;

function TDocumentFilesInfoHolder.GetNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.NameFieldName, '');
  
end;

function TDocumentFilesInfoHolder.GetPathFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.PathFieldName, '');
  
end;

function TDocumentFilesInfoHolder.GetDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentIdFieldName, Null);
  
end;

function TDocumentFilesInfoHolder.GetFieldNames: TDocumentFilesInfoFieldNames;
begin

  Result := TDocumentFilesInfoFieldNames(inherited FieldDefs);
  
end;

procedure TDocumentFilesInfoHolder.SetFieldNames(
  const Value: TDocumentFilesInfoFieldNames);
begin

  inherited FieldDefs := Value;
  
end;

end.
