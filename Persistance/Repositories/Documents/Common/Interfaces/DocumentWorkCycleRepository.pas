unit DocumentWorkCycleRepository;

interface

uses

  DocumentWorkCycle,
  SysUtils;

type

  IDocumentWorkCycleRepository = interface

    function FindWorkCycleForDocumentKind(const DocumentKindId: Variant): TDocumentWorkCycle;
    
  end;

implementation

end.
