unit AbstractDocumentDefaultSignerFinder;

interface

uses

  DocumentDefaultSignerFinder,
  Document,
  Employee,
  SysUtils;

type

  TAbstractDocumentDefaultSignerFinder =
    class (TInterfacedObject, IDocumentDefaultSignerFinder)

      public

        function FindDefaultDocumentSignerFor(
          Document: TDocument;
          Employee: TEmployee
        ): TEmployee; virtual; abstract;
        
    end;

implementation

end.
