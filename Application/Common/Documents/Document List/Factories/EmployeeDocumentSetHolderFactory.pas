unit EmployeeDocumentSetHolderFactory;

interface

uses

  AbstractDocumentSetHolderFactoryDecorator,
  AbstractDocumentSetHolderDecorator,
  EmployeeDocumentSetHolder,
  DocumentSetHolder,
  SysUtils;

type

  TEmployeeDocumentSetHolderFactory = class (TAbstractDocumentSetHolderFactoryDecorator)

    protected

      function GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass; override;

      procedure FillDocumentSetFieldDefs(DocumentSetHolder: TDocumentSetHolder); override;
    
  end;
  
implementation

uses

  DocumentsViewDef;

{ TEmployeeDocumentSetHolderFactory }

procedure TEmployeeDocumentSetHolderFactory.FillDocumentSetFieldDefs(
  DocumentSetHolder: TDocumentSetHolder);
begin

  inherited;

  with TEmployeeDocumentSetHolder(DocumentSetHolder) do begin

    IsViewedFieldName := DOCUMENT_VIEW_IS_VIEWED_FIELD;
    OwnChargeSheetFieldName := 'own_charge';
    AllChargeSheetsPerformedFieldName := 'all_emp_charge_sheets_performed';
    AllSubordinateChargeSheetsPerformedFieldName := 'all_subord_charges_performed'
    
  end;

end;

function TEmployeeDocumentSetHolderFactory.
  GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass;
begin

  Result := TEmployeeDocumentSetHolder;
  
end;

end.
