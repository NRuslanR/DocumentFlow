unit IncomingServiceNote;

interface

uses

  ServiceNote,
  Document,
  IncomingDocument,
  DocumentChargeSheet,
  SysUtils,
  Classes;

type

  TIncomingServiceNote = class (TIncomingDocument)

    private

      function GetOriginalServiceNote: TServiceNote;

    public

      class function ListType: TDocumentsClass; override;
      class function OutcomingDocumentType: TDocumentClass; override;

      property OriginalDocument: TServiceNote read GetOriginalServiceNote;

  end;

  TIncomingServiceNotes = class;
  
  TIncomingServiceNotesEnumerator = class (TIncomingDocumentsEnumerator)

    protected

      function GetCurrentIncomingServiceNote: TIncomingServiceNote;
      
    public

      constructor Create(IncomingServiceNotes: TIncomingServiceNotes);
      
      property Current: TIncomingServiceNote
      read GetCurrentIncomingServiceNote;
      
  end;

  TIncomingServiceNotes = class (TIncomingDocuments)

    protected

      function GetIncomingServiceNoteByIndex(
        Index: Integer
      ): TIncomingServiceNote;

      procedure SetIncomingServiceNoteByIndex(
        Index: Integer;
        const Value: TIncomingServiceNote
      );

    public

      function FindIncomingServiceNoteById(
        const ServiceNoteId: Variant
      ): TIncomingServiceNote;

      property Items[Index: Integer]: TIncomingServiceNote
      read GetIncomingServiceNoteByIndex
      write SetIncomingServiceNoteByIndex; default;

      function GetEnumerator: TIncomingServiceNotesEnumerator;

  end;

implementation
  
{ TIncomingServiceNote }

class function TIncomingServiceNote.ListType: TDocumentsClass;
begin

  Result := TIncomingServiceNotes;
  
end;

function TIncomingServiceNote.GetOriginalServiceNote: TServiceNote;
begin

  Result := FOriginalDocument as TServiceNote;
  
end;

class function TIncomingServiceNote.OutcomingDocumentType: TDocumentClass;
begin

  Result := TServiceNote;
  
end;

{ TIncomingServiceNotesEnumerator }

constructor TIncomingServiceNotesEnumerator.Create(
  IncomingServiceNotes: TIncomingServiceNotes);
begin

  inherited Create(IncomingServiceNotes);

end;

function TIncomingServiceNotesEnumerator.GetCurrentIncomingServiceNote: TIncomingServiceNote;
begin

  Result := GetCurrentIncomingDocument as TIncomingServiceNote;

end;

{ TIncomingServiceNotes }

function TIncomingServiceNotes.FindIncomingServiceNoteById(
  const ServiceNoteId: Variant): TIncomingServiceNote;
begin

  Result := FindDocumentById(ServiceNoteId) as TIncomingServiceNote;

end;

function TIncomingServiceNotes.GetEnumerator: TIncomingServiceNotesEnumerator;
begin

  Result := TIncomingServiceNotesEnumerator.Create(Self);
  
end;

function TIncomingServiceNotes.GetIncomingServiceNoteByIndex(
  Index: Integer): TIncomingServiceNote;
begin

  Result := GetDocumentByIndex(Index) as TIncomingServiceNote;

end;

procedure TIncomingServiceNotes.SetIncomingServiceNoteByIndex(Index: Integer;
  const Value: TIncomingServiceNote);
begin

  SetDocumentByIndex(Index, Value);
  
end;

end.
