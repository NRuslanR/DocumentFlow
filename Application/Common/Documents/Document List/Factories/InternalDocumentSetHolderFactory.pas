unit InternalDocumentSetHolderFactory;

interface

uses

  DocumentSetHolder,
  IncomingDocumentSetHolderFactory,
  AbstractDocumentSetHolderDecorator,
  AbstractDocumentSetHolderFactoryDecorator,
  SysUtils,
  Classes;

type

  TInternalDocumentSetHolderFactory = class (TAbstractDocumentSetHolderFactoryDecorator)

    protected

      function GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass; override;
      
  end;
  
implementation

uses

  InternalDocumentSetHolder;


{ TInternalDocumentSetHolderFactory }

function TInternalDocumentSetHolderFactory.GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass;
begin

  Result := TInternalDocumentSetHolder;

end;

end.
