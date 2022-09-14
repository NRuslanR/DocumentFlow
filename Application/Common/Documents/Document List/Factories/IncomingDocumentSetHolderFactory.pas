unit IncomingDocumentSetHolderFactory;

interface

uses

  AbstractDocumentSetHolderFactoryDecorator,
  AbstractDocumentSetHolderDecorator,
  DocumentSetHolder,
  DocumentSetHolderFactory;

type

  TIncomingDocumentSetHolderFactory = class (TAbstractDocumentSetHolderFactoryDecorator)

    protected

      function GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass; override;
      procedure FillDocumentSetFieldDefs(DocumentSetHolder: TDocumentSetHolder); override;

  end;

implementation

uses

  IncomingDocumentSetHolder;
  
{ TIncomingDocumentSetHolderFactory }

procedure TIncomingDocumentSetHolderFactory.FillDocumentSetFieldDefs(
  DocumentSetHolder: TDocumentSetHolder);
begin

  inherited;

  with TIncomingDocumentSetHolder(DocumentSetHolder) do begin

    NumberFieldName := 'outcomming_number';
    IncomingNumberFieldName := 'number';
    ReceiptDateFieldName := 'receipt_date';
    SendingDepartmentNameFieldName := 'department_name';
     
  end;
  
end;

function TIncomingDocumentSetHolderFactory.GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass;
begin

  Result := TIncomingDocumentSetHolder;
  
end;

end.
