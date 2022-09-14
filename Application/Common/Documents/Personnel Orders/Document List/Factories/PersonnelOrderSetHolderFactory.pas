unit PersonnelOrderSetHolderFactory;

interface

uses

  DocumentSetHolderFactory,
  DocumentSetHolder,
  PersonnelOrderSetHolder,
  SysUtils;

type

  TPersonnelOrderSetHolderFactory = class (TDocumentSetHolderFactory)

    protected

      function CreateDocumentSetHolderInstance: TDocumentSetHolder; override;
      procedure FillDocumentSetFieldDefs(DocumentSetHolder: TDocumentSetHolder); override;

  end;
  
implementation

uses

  PersonnelOrdersViewDef;
  
{ TPersonnelOrderSetHolderFactory }

function TPersonnelOrderSetHolderFactory.CreateDocumentSetHolderInstance: TDocumentSetHolder;
begin

  Result := TPersonnelOrderSetHolder.Create;
  
end;

procedure TPersonnelOrderSetHolderFactory.FillDocumentSetFieldDefs(
  DocumentSetHolder: TDocumentSetHolder);
begin

  inherited;

  with TPersonnelOrderSetHolder(DocumentSetHolder) do begin

    SubKindIdFieldName := PERSONNEL_ORDERS_VIEW_SUB_KIND_ID_FIELD;
    SubKindNameFieldName := PERSONNEL_ORDERS_VIEW_SUB_KIND_NAME_FIELD;
    
  end;

end;

end.
