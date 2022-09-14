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

      DocumentFileIdFieldName: String;
      DocumentFileNameFieldName: String;
      DocumentFilePathFieldName: String;
      DocumentIdFieldName: String;
      
  end;

  TDocumentFilesInfoHolder = class (TAbstractDataSetHolder)

    private

      function GetDocumentIdFieldValue: Variant;
      function GetDocumentFileIdFieldValue: Variant;
      function GetDocumentFileNameFieldValue: String;
      function GetDocumentFilePathFieldValue: String;
      function GetFieldNames: TDocumentFilesInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentFilesInfoFieldNames);

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public

      property FieldNames: TDocumentFilesInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property DocumentIdFieldValue: Variant
      read GetDocumentIdFieldValue;
      
      property DocumentFileIdFieldValue: Variant
      read GetDocumentFileIdFieldValue;

      property DocumentFileNameFieldValue: String
      read GetDocumentFileNameFieldValue;

      property DocumentFilePathFieldValue: String
      read GetDocumentFilePathFieldValue;

  end;

implementation

uses

  Variants;

{ TDocumentFilesInfoHolder }

class function TDocumentFilesInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentFilesInfoFieldNames;
  
end;

function TDocumentFilesInfoHolder.GetDocumentFileIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentFileIdFieldName, Null);
  
end;

function TDocumentFilesInfoHolder.GetDocumentFileNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentFileNameFieldName, '');
  
end;

function TDocumentFilesInfoHolder.GetDocumentFilePathFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentFilePathFieldName, '');
  
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
