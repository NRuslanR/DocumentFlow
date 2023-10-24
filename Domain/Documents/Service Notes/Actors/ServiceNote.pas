unit ServiceNote;

interface

uses

  Document,
  DocumentPerformingSheet,
  DocumentWorkCycle,
  DocumentChargeSheet;

type

  TServiceNote = class (TDocument)

    protected

    public

      class function IncomingDocumentType: TDocumentClass; override;
      class function ListType: TDocumentsClass; override;

  end;

  TServiceNotes = class;

  TServiceNotesEnumerator = class (TDocumentsEnumerator)

    protected

      function GetCurrentServiceNote: TServiceNote;
      
    public

      constructor Create(ServiceNotes: TServiceNotes);

      property Current: TServiceNote read GetCurrentServiceNote;

  end;

  TServiceNotes = class (TDocuments)

    private

      function GetServiceNoteByIndex(Index: Integer): TServiceNote;
      procedure SetServiceNoteByIndex(
        Index: Integer;
        Value: TServiceNote
      );

    public

      function FindServiceNoteById(
          const ServiceNoteId: Variant
        ): TServiceNote;

      property Items[Index: Integer]: TServiceNote
      read GetServiceNoteByIndex
      write SetServiceNoteByIndex; default;

      function GetEnumerator: TServiceNotesEnumerator;

  end;

implementation

uses

  IncomingServiceNote;
  
{ TServiceNotesEnumerator }

constructor TServiceNotesEnumerator.Create(ServiceNotes: TServiceNotes);
begin

  inherited Create(ServiceNotes);
  
end;

function TServiceNotesEnumerator.GetCurrentServiceNote: TServiceNote;
begin

  Result := GetCurrentDocument as TServiceNote;

end;

{ TServiceNotes }

function TServiceNotes.FindServiceNoteById(
  const ServiceNoteId: Variant): TServiceNote;
begin

  Result := FindDocumentById(ServiceNoteId) as TServiceNote;

end;

function TServiceNotes.GetEnumerator: TServiceNotesEnumerator;
begin

  Result := TServiceNotesEnumerator.Create(Self);
  
end;

function TServiceNotes.GetServiceNoteByIndex(Index: Integer): TServiceNote;
begin

  Result := GetDocumentByIndex(Index) as TServiceNote;

end;

procedure TServiceNotes.SetServiceNoteByIndex(Index: Integer;
  Value: TServiceNote);
begin

  SetDocumentByIndex(Index, Value);
  
end;

{ TServiceNote }

class function TServiceNote.IncomingDocumentType: TDocumentClass;
begin

  Result := TIncomingServiceNote;
  
end;

class function TServiceNote.ListType: TDocumentsClass;
begin

  Result := TServiceNotes;
  
end;

end.
