unit PersonnelOrderFullInfoDataSetHolder;

interface

uses

  PersonnelOrderInfoHolder,
  DocumentInfoHolder,
  DocumentFullInfoDataSetHolder,
  SysUtils;

type

  TPersonnelOrderFullInfoDataSetFieldNames = class (TDocumentFullInfoDataSetFieldNames)

    private

      function GetSubKindIdFieldName: String;
      function GetSubKindNameFieldName: String;
      procedure SetSubKindIdFieldName(const Value: String);
      procedure SetSubKindNameFieldName(const Value: String);
    
    public

      property SubKindIdFieldName: String
      read GetSubKindIdFieldName write SetSubKindIdFieldName;

      property SubKindNameFieldName: String
      read GetSubKindNameFieldName write SetSubKindNameFieldName;

  end;
  
  TPersonnelOrderFullInfoDataSetHolder = class (TDocumentFullInfoDataSetHolder)

    protected

      function CreateDocumentInfoHolderInstance: TDocumentInfoHolder; override;

  end;
  
implementation

{ TPersonnelOrderFullInfoDataSetHolder }

function TPersonnelOrderFullInfoDataSetHolder.CreateDocumentInfoHolderInstance: TDocumentInfoHolder;
begin

  Result := TPersonnelOrderInfoHolder.Create;

end;

{ TPersonnelOrderFullInfoDataSetFieldNames }

function TPersonnelOrderFullInfoDataSetFieldNames.GetSubKindIdFieldName: String;
begin

  Result :=
    TPersonnelOrdeInfoFieldNames(DocumentInfoFieldNames).SubKindIdFieldName;
  
end;

function TPersonnelOrderFullInfoDataSetFieldNames.GetSubKindNameFieldName: String;
begin

  Result :=
    TPersonnelOrdeInfoFieldNames(DocumentInfoFieldNames).SubKindIdFieldName;

end;

procedure TPersonnelOrderFullInfoDataSetFieldNames.SetSubKindIdFieldName(
  const Value: String);
begin

  TPersonnelOrdeInfoFieldNames(DocumentInfoFieldNames).SubKindIdFieldName := Value;
  
end;

procedure TPersonnelOrderFullInfoDataSetFieldNames.SetSubKindNameFieldName(
  const Value: String);
begin

  TPersonnelOrdeInfoFieldNames(DocumentInfoFieldNames).SubKindNameFieldName := Value;
  
end;

end.
