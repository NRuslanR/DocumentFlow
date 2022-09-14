unit ApproveableDocumentSetHolderFactory;

interface

uses

  DocumentSetHolderFactory,
  DocumentSetHolder,
  ApproveableDocumentSetHolder,
  AbstractDocumentSetHolderFactoryDecorator,
  AbstractDocumentSetHolderDecorator,
  SysUtils;

type

  TApproveableDocumentSetHolderFactory = class (TAbstractDocumentSetHolderFactoryDecorator)

    protected

      function GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass; override;

      procedure FillDocumentSetFieldDefs(DocumentSetHolder: TDocumentSetHolder); override;

  end;

implementation

{ TApproveableDocumentSetHolderFactory }

procedure TApproveableDocumentSetHolderFactory.FillDocumentSetFieldDefs(
  DocumentSetHolder: TDocumentSetHolder);
begin

  inherited FillDocumentSetFieldDefs(DocumentSetHolder);

  with TApproveableDocumentSetHolder(DocumentSetHolder) do begin

    SenderDepartmentNameFieldName := 'sender_department_name';
    ReceiverDepartmentNamesFieldName := 'receiver_department_names';
    
  end;

end;

function TApproveableDocumentSetHolderFactory.GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass;
begin

  Result := TApproveableDocumentSetHolder;
  
end;

end.
