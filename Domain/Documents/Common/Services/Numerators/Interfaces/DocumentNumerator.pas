unit DocumentNumerator;

interface

uses

  DomainException;
  
type

  TDocumentNumeratorException = class (TDomainException)

  end;
  
  IDocumentNumerator = interface

    function CreateNewDocumentNumber: String;
    procedure Reset;
    
  end;
  
implementation

end.
