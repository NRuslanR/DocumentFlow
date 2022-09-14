unit OutcomingDocumentSetHolderFactory;

interface

uses

  AbstractDocumentSetHolderDecorator,
  AbstractDocumentSetHolderFactoryDecorator,
  DocumentSetHolder,
  DocumentSetHolderFactory;

type

  TOutcomingDocumentSetHolderFactory = class (TAbstractDocumentSetHolderFactoryDecorator)

    protected

      function GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass; override;
      procedure FillDocumentSetFieldDefs(DocumentSetHolder: TDocumentSetHolder); override;

  end;

implementation

uses

  OutcomingDocumentSetHolder;
  
{ TOutcomingDocumentSetHolderFactory }

procedure TOutcomingDocumentSetHolderFactory.FillDocumentSetFieldDefs(
  DocumentSetHolder: TDocumentSetHolder);
begin

  inherited FillDocumentSetFieldDefs(DocumentSetHolder);

  with TOutcomingDocumentSetHolder(DocumentSetHolder) do begin

    ReceivingDepartmentNamesFieldName := 'department_name';
     
  end;

end;


function TOutcomingDocumentSetHolderFactory.
  GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass;
begin

  Result := TOutcomingDocumentSetHolder;
  
end;

end.
