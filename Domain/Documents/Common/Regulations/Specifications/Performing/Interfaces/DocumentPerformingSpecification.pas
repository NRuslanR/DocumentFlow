unit DocumentPerformingSpecification;

interface

uses

  IDocumentUnit,
  SysUtils,
  Classes;

type

  IDocumentPerformingSpecification = interface
    ['{4F14DEE3-1507-4DEC-8889-B01EA0D27726}']

    function IsDocumentSentToPerforming(Document: IDocument): Boolean;
    
  end;

implementation

end.
