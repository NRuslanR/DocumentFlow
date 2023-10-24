unit FormalDocumentSignerFinder;

interface

uses

  DomainException,
  Employee,
  IDocumentUnit,
  Document,
  SysUtils;

type

  TFormalDocumentSignerFinder = class (TDomainException)

  end;
  
  IFormalDocumentSignerFinder = interface
    ['{935DA2CD-AD76-47E5-B512-2AE61DC34CEF}']

    function GetFormalDocumentSigner(Document: IDocument): TEmployee;
    
  end;

implementation

end.
