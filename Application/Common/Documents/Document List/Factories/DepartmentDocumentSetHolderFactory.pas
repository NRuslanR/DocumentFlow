unit DepartmentDocumentSetHolderFactory;

interface

uses

  AbstractDocumentSetHolderFactoryDecorator,
  AbstractDocumentSetHolderDecorator,
  DepartmentDocumentSetHolder,
  SysUtils;

type

  TDepartmentDocumentSetHolderFactory = class (TAbstractDocumentSetHolderFactoryDecorator)

    protected

      function GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass; override;
    
  end;
  
implementation

{ TDepartmentDocumentSetHolderFactory }

function TDepartmentDocumentSetHolderFactory.
  GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass;
begin

  Result := TDepartmentDocumentSetHolder;
  
end;

end.
