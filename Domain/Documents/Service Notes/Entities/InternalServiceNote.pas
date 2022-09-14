unit InternalServiceNote;

interface

uses

  InternalDocument,
  ServiceNote,
  DocumentChargeSheet,
  Document,
  Employee,
  SysUtils,
  Classes;

type

  TInternalServiceNote = class (TInternalDocument)

    private

      function GetOriginalServiceNote: TServiceNote;

    public

      class function ListType: TDocumentsClass; override;
      class function IncomingDocumentType: TDocumentClass; override;
      
      property OriginalDocument: TServiceNote read GetOriginalServiceNote;
    
  end;

  TInternalServiceNotes = class;

  TInternalServiceNotesEnumerator = class (TInternalDocumentsEnumerator)

    protected

      function GetCurrentInternalServiceNote: TInternalServiceNote;
      
    public

      constructor Create(InternalServiceNotes: TInternalServiceNotes);
      
      property Current: TInternalServiceNote
      read GetCurrentInternalServiceNote;
      
  end;

  TInternalServiceNotes = class (TInternalDocuments)

    protected

      function GetInternalServiceNoteByIndex(
        Index: Integer
      ): TInternalServiceNote;

      procedure SetInternalServiceNoteByIndex(
        Index: Integer;
        const Value: TInternalServiceNote
      );

    public

      function FindInternalServiceNoteById(
        const ServiceNoteId: Variant
      ): TInternalServiceNote;

      property Items[Index: Integer]: TInternalServiceNote
      read GetInternalServiceNoteByIndex
      write SetInternalServiceNoteByIndex; default;

      function GetEnumerator: TInternalServiceNotesEnumerator;

  end;

implementation

uses

  IncomingInternalServiceNote;
  
{ TInternalServiceNote }

class function TInternalServiceNote.ListType: TDocumentsClass;
begin

  Result := TInternalServiceNotes;
  
end;

function TInternalServiceNote.GetOriginalServiceNote: TServiceNote;
begin

  Result := FOriginalDocument as TServiceNote;

end;

class function TInternalServiceNote.IncomingDocumentType: TDocumentClass;
begin

  Result := TIncomingInternalServiceNote;
  
end;

{ TInternalServiceNotesEnumerator }

constructor TInternalServiceNotesEnumerator.Create(
  InternalServiceNotes: TInternalServiceNotes
);
begin

  inherited Create(InternalServiceNotes);

end;

function TInternalServiceNotesEnumerator.
  GetCurrentInternalServiceNote: TInternalServiceNote;
begin

  Result := TInternalServiceNote(GetCurrentDocument);

end;

{ TInternalServiceNotes }

function TInternalServiceNotes.FindInternalServiceNoteById(
  const ServiceNoteId: Variant): TInternalServiceNote;
begin

  Result := TInternalServiceNote(FindDocumentById(ServiceNoteId));
  
end;

function TInternalServiceNotes.GetEnumerator: TInternalServiceNotesEnumerator;
begin

  Result := TInternalServiceNotesEnumerator.Create(Self);
  
end;

function TInternalServiceNotes.GetInternalServiceNoteByIndex(
  Index: Integer): TInternalServiceNote;
begin

  Result := TInternalServiceNote(GetDocumentByIndex(Index));
  
end;

procedure TInternalServiceNotes.SetInternalServiceNoteByIndex(Index: Integer;
  const Value: TInternalServiceNote);
begin

  SetDocumentByIndex(Index, Value);
  
end;

end.
