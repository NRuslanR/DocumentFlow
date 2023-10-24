unit DocumentWorkCycleFinder;

interface

uses

  DocumentWorkCycle;

type

  IDocumentWorkCycleFinder = interface

    function FindWorkCycleForDocumentKind(const DocumentKindId: Variant): TDocumentWorkCycle;
    
  end;
  
implementation

end.
