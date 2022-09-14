unit StandardDocumentFullNameCompilationService;

interface

uses

  DocumentFullNameCompilationService,
  DocumentRegistrationService,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TStandardDocumentFullNameCompilationService =
    class (TInterfacedObject, IDocumentFullNameCompilationService)

      private

      protected

        function GetKindNameForDocument(Document: IDocument): String; virtual;

        function AreDocumentNumberAndDocumentDateCorrect(
          const DocumentNumber: String;
          const DocumentDate: Variant
        ): Boolean;

      public

        constructor Create;
        
        function CompileFullNameForDocument(Document: IDocument): String; virtual;
        function CompileNameWithoutManualNameForDocument(Document: IDocument): String; virtual;

    end;

implementation

uses

  DateUtils,
  Document,
  Variants,
  ServiceNote,
  PersonnelOrder,
  InternalServiceNote,
  IncomingInternalServiceNote,
  IncomingServiceNote;

{ TStandardDocumentFullNameCompilationService }

function TStandardDocumentFullNameCompilationService.AreDocumentNumberAndDocumentDateCorrect(
  const DocumentNumber: String; const DocumentDate: Variant): Boolean;
var Year, Month, Day, Hour, Minute, Seconds, Placeholder: Word;
begin

  if VarIsNull(DocumentDate) then begin

    Result := False;
    Exit;
    
  end;

  DecodeDateTime(
    DocumentDate, Year, Month, Day, Hour, Minute, Seconds, Placeholder
  );

  Result :=
    (DocumentNumber <> '') and
    IsValidDateTime(
      Year, Month, Day,
      Hour, Minute, Seconds,
      Placeholder
    );
    
end;

function TStandardDocumentFullNameCompilationService.CompileFullNameForDocument(
  Document: IDocument
): String;
begin

  Result := CompileNameWithoutManualNameForDocument(Document);

  if Trim(Document.Name) <> '' then
    Result := Result + ': ' + Document.Name;
  
end;

function TStandardDocumentFullNameCompilationService.
  CompileNameWithoutManualNameForDocument(
    Document: IDocument
  ): String;
var
    DocumentKindName: String;
    DocumentNumber: String;
    DocumentDateString: String;
begin

  DocumentKindName := GetKindNameForDocument(Document);
  DocumentNumber := Document.Number;
  DocumentDateString := VarToStr(Document.DocumentDate);

  if

      AreDocumentNumberAndDocumentDateCorrect(
        DocumentNumber, Document.DocumentDate
      )

  then begin

     Result :=
      Format(
        '%s №%s от %s',
        [
          DocumentKindName,
          DocumentNumber,
          DocumentDateString
        ]
      );

   end

  else Result := Format('%s', [DocumentKindName]);

end;

constructor TStandardDocumentFullNameCompilationService.Create;
begin

  inherited Create;

end;

function TStandardDocumentFullNameCompilationService.GetKindNameForDocument(
  Document: IDocument): String;
var RealDocument: TDocument;
begin

  RealDocument := Document.Self as TDocument;

  if (RealDocument.ClassType = TServiceNote) or
     (RealDocument.ClassType = TIncomingServiceNote) or
     (RealDocument.ClassType = TInternalServiceNote) or
     (RealDocument.ClassType = TIncomingInternalServiceNote)

  then Result := 'с/з'

  else if (RealDocument.ClassType = TPersonnelOrder) then
    Result := 'кадровый приказ'

  else Result := '';

end;

end.
