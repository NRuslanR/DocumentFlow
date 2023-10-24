unit DocumentDefaultSignerFinder;

interface

uses

  Employee,
  Document,
  SysUtils;

type

  IDocumentDefaultSignerFinder = interface

    function FindDefaultDocumentSignerFor(
      Document: TDocument;
      Employee: TEmployee
    ): TEmployee;
    
  end;

implementation

end.
