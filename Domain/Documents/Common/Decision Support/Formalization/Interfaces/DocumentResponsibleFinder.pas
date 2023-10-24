unit DocumentResponsibleFinder;

interface

uses

  Employee;

type

  IDocumentResponsibleFinder = interface

    function FindDocumentResponsibleById(
      const DocumentResponsibleId: Variant
    ): TEmployee;

  end;
  
implementation

end.
