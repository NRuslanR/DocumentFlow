unit PersonnelOrderInfoHolderBuilder;

interface

uses

  DocumentInfoHolder,
  DocumentInfoHolderBuilder,
  PersonnelOrderInfoHolder,
  SysUtils;

type

  TPersonnelOrderInfoHolderBuilder = class (TDocumentInfoHolderBuilder)

    protected

      function CreateDocumentInfoHolderInstance: TDocumentInfoHolder; override;
      function CreateDocumentInfoFieldNamesInstance: TDocumentInfoFieldNames; override;
      procedure FillDocumentInfoFieldNames(FieldNames: TDocumentInfoFieldNames); override;
      
  end;
  
implementation

{ TPersonnelOrderInfoHolderBuilder }

{ TPersonnelOrderInfoHolderBuilder }

function TPersonnelOrderInfoHolderBuilder.CreateDocumentInfoFieldNamesInstance: TDocumentInfoFieldNames;
begin

  Result := TPersonnelOrdeInfoFieldNames.Create;

end;

function TPersonnelOrderInfoHolderBuilder.CreateDocumentInfoHolderInstance: TDocumentInfoHolder;
begin

  Result := TPersonnelOrderInfoHolder.Create;

end;

procedure TPersonnelOrderInfoHolderBuilder.FillDocumentInfoFieldNames(
  FieldNames: TDocumentInfoFieldNames);
begin

  inherited FillDocumentInfoFieldNames(FieldNames);

  with TPersonnelOrdeInfoFieldNames(FieldNames) do begin

    IsSelfRegisteredFieldName := '';
    SubKindIdFieldName := 'sub_type_id';
    SubKindNameFieldName := 'sub_type_name';

  end;

end;

end.
