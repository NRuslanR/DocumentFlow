unit DocumentFullNameCompilationService;

interface

uses

  IDocumentUnit;

type

  IDocumentFullNameCompilationService = interface

    function CompileFullNameForDocument(Document: IDocument): String;
    function CompileNameWithoutManualNameForDocument(Document: IDocument): String;

  end;
  
implementation

end.
