unit DocumentCreatingDefaultInfoDataSetHolder;

interface

uses

  DB,
  SysUtils,
  Classes;

type

  TDocumentCreatingDefaultInfoDataSetFieldNames = class

    DocumentResponsibleIdFieldName: String;
    DocumentResponsibleNameFieldName: String;
    DocumentResponsibleTelephoneNumberFieldName: String;
    DocumentResponsibleDepartmentIdFieldName: String;
    DocumentResponsibleDepartmentCodeFieldName: String;
    DocumentResponsibleDepartmentNameFieldName: String;

    DocumentSignerIdFieldName: String;
    DocumentSignerLeaderIdFieldName: String;
    DocumentSignerRoleIdFieldName: String;
    DocumentSignerIsForeignFieldName: String;
    DocumentSignerNameFieldName: String;
    DocumentSignerSpecialityFieldName: String;
    DocumentSignerDepartmentIdFieldName: String;
    DocumentSignerDepartmentCodeFieldName: String;
    DocumentSignerDepartmentNameFieldName: String;

  end;
  
  TDocumentCreatingDefaultInfoDataSetHolder = class

    private

      FDataSet: TDataSet;
      FFieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames;

    private
    
      function GetDocumentResponsibleDepartmentCodeFieldValue: String;
      function GetDocumentResponsibleDepartmentIdFieldValue: Variant;
      function GetDocumentResponsibleDepartmentNameFieldValue: String;
      function GetDocumentResponsibleIdFieldValue: Variant;
      function GetDocumentResponsibleNameFieldValue: String;
      function GetDocumentResponsibleTelephoneNumberFieldValue: Variant;
      function GetDocumentSignerDepartmentCodeFieldValue: String;
      function GetDocumentSignerDepartmentIdFieldValue: Variant;
      function GetDocumentSignerDepartmentNameFieldValue: String;
      function GetDocumentSignerIdFieldValue: Variant;
      function GetDocumentSignerIsForeignFieldValue: Boolean;
      function GetDocumentSignerLeaderIdFieldValue: Variant;
      function GetDocumentSignerNameFieldValue: String;
      function GetDocumentSignerRoleIdFieldValue: Variant;
      function GetDocumentSignerSpecialityFieldValue: String;

    public

      destructor Destroy; override;

      constructor CreateFrom(
        DataSet: TDataSet;
        FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames
      );
      
    public

      property DocumentResponsibleIdFieldValue: Variant
      read GetDocumentResponsibleIdFieldValue;
      
      property DocumentResponsibleNameFieldValue: String
      read GetDocumentResponsibleNameFieldValue;

      property DocumentResponsibleTelephoneNumberFieldValue: Variant
      read GetDocumentResponsibleTelephoneNumberFieldValue;
      
      property DocumentResponsibleDepartmentIdFieldValue: Variant
      read GetDocumentResponsibleDepartmentIdFieldValue;
      
      property DocumentResponsibleDepartmentCodeFieldValue: String
      read GetDocumentResponsibleDepartmentCodeFieldValue;
      
      property DocumentResponsibleDepartmentNameFieldValue: String
      read GetDocumentResponsibleDepartmentNameFieldValue;

    public
    
      property DocumentSignerIdFieldValue: Variant
      read GetDocumentSignerIdFieldValue;

      property DocumentSignerLeaderIdFieldValue: Variant
      read GetDocumentSignerLeaderIdFieldValue;
      
      property DocumentSignerRoleIdFieldValue: Variant
      read GetDocumentSignerRoleIdFieldValue;
      
      property DocumentSignerIsForeignFieldValue: Boolean
      read GetDocumentSignerIsForeignFieldValue;
      
      property DocumentSignerNameFieldValue: String
      read GetDocumentSignerNameFieldValue;

      property DocumentSignerSpecialityFieldValue: String
      read GetDocumentSignerSpecialityFieldValue;
      
      property DocumentSignerDepartmentIdFieldValue: Variant
      read GetDocumentSignerDepartmentIdFieldValue;
      
      property DocumentSignerDepartmentCodeFieldValue: String
      read GetDocumentSignerDepartmentCodeFieldValue;
      
      property DocumentSignerDepartmentNameFieldValue: String
      read GetDocumentSignerDepartmentNameFieldValue;

    public

      property DataSet: TDataSet read FDataSet write FDataSet;
      property FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames
      read FFieldNames write FFieldNames;

  end;
  
implementation

{ TDocumentCreatingDefaultInfoDataSetHolder }

constructor TDocumentCreatingDefaultInfoDataSetHolder.CreateFrom(
  DataSet: TDataSet; FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames);
begin

  Create;

  FDataSet := DataSet;
  FFieldNames := FieldNames;
  
end;

destructor TDocumentCreatingDefaultInfoDataSetHolder.Destroy;
begin

  FreeAndNil(FDataSet);
  FreeAndNil(FFieldNames);
  inherited;

end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentResponsibleDepartmentCodeFieldValue: String;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentResponsibleDepartmentCodeFieldName).AsString;

end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentResponsibleDepartmentIdFieldValue: Variant;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentResponsibleDepartmentIdFieldName).AsVariant;

end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentResponsibleDepartmentNameFieldValue: String;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentResponsibleDepartmentNameFieldName).AsString;

end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentResponsibleIdFieldValue: Variant;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentResponsibleIdFieldName).AsVariant;
  
end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentResponsibleNameFieldValue: String;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentResponsibleNameFieldName).AsString;

end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentResponsibleTelephoneNumberFieldValue: Variant;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentResponsibleTelephoneNumberFieldName).AsVariant;

end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentSignerDepartmentCodeFieldValue: String;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentSignerDepartmentCodeFieldName).AsString;
  
end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentSignerDepartmentIdFieldValue: Variant;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentSignerDepartmentIdFieldName).AsVariant;

end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentSignerDepartmentNameFieldValue: String;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentSignerDepartmentNameFieldName).AsString;
  
end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentSignerIdFieldValue: Variant;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentSignerIdFieldName).AsVariant;

end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentSignerIsForeignFieldValue: Boolean;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentSignerIsForeignFieldName).AsBoolean;
  
end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentSignerLeaderIdFieldValue: Variant;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentSignerLeaderIdFieldName).AsVariant;
  
end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentSignerNameFieldValue: String;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentSignerNameFieldName).AsString;
  
end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentSignerRoleIdFieldValue: Variant;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentSignerRoleIdFieldName).AsVariant;
  
end;

function TDocumentCreatingDefaultInfoDataSetHolder.GetDocumentSignerSpecialityFieldValue: String;
begin

  Result := FDataSet.FieldByName(FFieldNames.DocumentSignerSpecialityFieldName).AsString;
  
end;

end.
