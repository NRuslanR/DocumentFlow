unit StandardDocumentPersistingValidator;

interface

uses

  DocumentPersistingValidator,
  DocumentFinder,
  IDocumentUnit,
  Document,
  SysUtils,
  Classes;

type

  TStandardDocumentPersistingValidator =
    class (TAbstractDocumentPersistingValidator)

      private

        FDocumentFinder: IDocumentFinder;

      public

        constructor Create(DocumentFinder: IDocumentFinder);

        procedure EnsureDocumentMayBePuttedInDirectory(Document: TDocument); override;
        procedure EnsureDocumentMayBeModifiedInDirectory(Document: TDocument); override;

        procedure EnsureDocumentsMayBePuttedInDirectory(Documents: TDocuments); override;
        procedure EnsureDocumentsMayBeModifiedInDirectory(Documents: TDocuments); override;

    end;

implementation

uses

  DateUtils,
  AuxiliaryStringFunctions,
  AuxDebugFunctionsUnit,
  AuxCollectionFunctionsUnit,
  IDomainObjectBaseListUnit;
  
{ TStandardDocumentPersistingValidator }

constructor TStandardDocumentPersistingValidator.Create(
  DocumentFinder: IDocumentFinder);
begin

  inherited Create;

  FDocumentFinder := DocumentFinder;
  
end;

procedure TStandardDocumentPersistingValidator.EnsureDocumentMayBePuttedInDirectory(
  Document: TDocument);
var
    DupDocuments: TDocuments;
    Free: IDomainObjectBaseList;
begin

  if not Document.IsNumberAssigned then Exit;

  DupDocuments :=
    FDocumentFinder
      .FindDocumentsByNumberAndCreationYear(Document.Number, YearOf(Now));

  Free := DupDocuments;

  if Assigned(DupDocuments) and not DupDocuments.IsEmpty then begin

    Raise TDocumentPersistingValidatonException.CreateFmt(
      'ƒокумент с номером "%s" уже существует',
      [
        Document.Number
      ]
    );

  end;

end;

procedure TStandardDocumentPersistingValidator.EnsureDocumentsMayBePuttedInDirectory(
  Documents: TDocuments);
var
    AssignableNumberDocuments: TDocuments;
    FreeAssignableNumberDocuments: IDomainObjectBaseList;

    DocumentNumbers: TStrings;
    DupDocumentNumbers: TStrings;

    DupDocuments: TDocuments;
    FreeDupDocuments: IDomainObjectBaseList;
begin

  AssignableNumberDocuments := Documents.FindDocumentsWithAssignedNumbers;

  FreeAssignableNumberDocuments := AssignableNumberDocuments;

  if AssignableNumberDocuments.IsEmpty then Exit;

  DocumentNumbers := AssignableNumberDocuments.ExtractDocumentNumbers;
  DupDocumentNumbers := GetDuplicateValues(DocumentNumbers);
  
  try

    if DupDocumentNumbers.Count > 0 then begin

      Raise TDocumentPersistingValidatonException.CreateFmt(
        'ѕопытка добавлени€ документов с ' +
        'одинаковым номером "%s"',
        [
          DupDocumentNumbers[0]
        ]
      );
      
    end;

    DupDocuments :=
      FDocumentFinder
        .FindDocumentsByNumbersAndCreationYear(DocumentNumbers, YearOf(Now));

    FreeDupDocuments := DupDocuments;

    if Assigned(DupDocuments) and not DupDocuments.IsEmpty then begin

      Raise TDocumentPersistingValidatonException.CreateFmt(
        'ƒокумент с номером "%s" уже существует',
        [
          DupDocuments.FirstDocument.Number
        ]
      );

    end;
    
  finally

    FreeAndNil(DocumentNumbers);
    FreeAndNil(DupDocumentNumbers);

  end;
  
end;

procedure TStandardDocumentPersistingValidator.EnsureDocumentMayBeModifiedInDirectory(
  Document: TDocument);
var
    DupDocuments: TDocuments;
    Free: IDomainObjectBaseList;
begin

  if not Document.IsNumberAssigned then Exit;

  DupDocuments :=
    FDocumentFinder
      .FindDocumentsByNumberAndCreationYear(Document.Number, YearOf(Now));

  Free := DupDocuments;

  if
    Assigned(DupDocuments)
    and (
      (DupDocuments.Count > 1)
      or (
        (DupDocuments.Count = 1)
        and (DupDocuments.FirstDocument.Identity <> Document.Identity)
      )
    )

  then begin

    Raise TDocumentPersistingValidatonException.CreateFmt(
      'ƒокумент с номером "%s" уже существует',
      [
        Document.Number
      ]
    );

  end;
  
end;

procedure TStandardDocumentPersistingValidator.EnsureDocumentsMayBeModifiedInDirectory(
  Documents: TDocuments);
var
    AssignableNumberDocuments: TDocuments;
    FreeAssignableNumberDocuments: IDomainObjectBaseList;
    
    DocumentNumbers, DupDocumentNumbers: TStrings;

    DupDocuments, SubDupDocuments: TDocuments;
    FreeDupDocuments, FreeSubDupDocuments: IDomainObjectBaseList;

    Document: TDocument;
begin

  AssignableNumberDocuments := Documents.FindDocumentsWithAssignedNumbers;

  FreeAssignableNumberDocuments := AssignableNumberDocuments;

  if AssignableNumberDocuments.IsEmpty then Exit;

  DocumentNumbers := AssignableNumberDocuments.ExtractDocumentNumbers;
  DupDocumentNumbers := GetDuplicateValues(DocumentNumbers);

  try

    if DupDocumentNumbers.Count > 0 then begin

      Raise TDocumentPersistingValidatonException.CreateFmt(
        'ѕопытка изменени€ документов с ' +
        'одинаковым номером "%s"',
        [
          DupDocumentNumbers[0]
        ]
      );
      
    end;

    DupDocuments :=
      FDocumentFinder
        .FindDocumentsByNumbersAndCreationYear(DocumentNumbers, YearOf(Now));

    FreeDupDocuments := DupDocuments;

    if not Assigned(DupDocuments) or DupDocuments.IsEmpty then Exit;

    for Document in AssignableNumberDocuments do begin

      SubDupDocuments := DupDocuments.GetDocumentsByNumber(Document.Number);

      FreeSubDupDocuments := SubDupDocuments;

      if SubDupDocuments.IsEmpty then Continue;
      
      if
        (SubDupDocuments.Count > 1)
        or (SubDupDocuments.FirstDocument.Identity <> Document.Identity)
      then begin
      
        Raise TDocumentPersistingValidatonException.Create(
          'ƒокументы с такими номерами уже существуют'
        );

      end;

    end;

  finally

    FreeAndNil(DocumentNumbers);
    FreeAndNil(DupDocumentNumbers);

  end;
  
end;

end.
